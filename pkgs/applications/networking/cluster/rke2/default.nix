{ lib, stdenv, buildGoModule, fetchFromGitHub, makeWrapper, nix-update-script

# Runtime dependencies
, procps, coreutils, util-linux, ethtool, socat, iptables, bridge-utils, iproute2, kmod, lvm2

# Testing dependencies
, nixosTests, testers, rke2
}:

buildGoModule rec {
  pname = "rke2";
  version = "1.29.0+rke2r1";

  src = fetchFromGitHub {
    owner = "rancher";
    repo = pname;
    rev = "v${version}";
    hash = "sha256-E59GUcbnbvsGZYn87RGNrGTVUsydKsjL+C5h15q74p0=";
  };

  vendorHash = "sha256-Og0CqxNnhRN6PdggneGK05uprZ2D7lux/snXcArIm8Q=";

  postPatch = ''
    # Patch the build scripts so they work in the Nix build environment.
    patchShebangs ./scripts

    # Disable the static build as it breaks.
    sed -e 's/STATIC_FLAGS=.*/STATIC_FLAGS=/g' -i scripts/build-binary
  '';

  nativeBuildInputs = [ makeWrapper ];

  # Important utilities used by the kubelet.
  # See: https://github.com/kubernetes/kubernetes/issues/26093#issuecomment-237202494
  # Notice the list in that issue is stale, but as a redundancy reservation.
  buildInputs = [
    procps # pidof pkill
    coreutils # uname touch env nice du
    util-linux # lsblk fsck mkfs nsenter mount umount
    ethtool # ethtool
    socat # socat
    iptables # iptables iptables-restore iptables-save
    bridge-utils # brctl
    iproute2 # ip tc
    kmod # modprobe
    lvm2 # dmsetup
  ];

  buildPhase = ''
    DRONE_TAG="v${version}" ./scripts/build-binary
  '';

  installPhase = ''
    install -D ./bin/rke2 $out/bin/rke2
    wrapProgram $out/bin/rke2 \
      --prefix PATH : ${lib.makeBinPath buildInputs}
  '';

  passthru.updateScript = nix-update-script { };

  passthru.tests = {
    version = testers.testVersion {
      package = rke2;
      version = "v${version}";
    };
  } // lib.optionalAttrs stdenv.isLinux {
    inherit (nixosTests) rke2;
  };

  meta = with lib; {
    homepage = "https://github.com/rancher/rke2";
    description = "RKE2, also known as RKE Government, is Rancher's next-generation Kubernetes distribution.";
    changelog = "https://github.com/rancher/rke2/releases/tag/v${version}";
    license = licenses.asl20;
    maintainers = with maintainers; [ zimbatm zygot ];
    mainProgram = "rke2";
    platforms = platforms.linux;
  };
}
