{ lib
, fetchFromGitHub
, stdenv
, makeWrapper
, qemu
, gnugrep
, gnused
, lsb-release
, jq
, procps
, python3
, cdrtools
, usbutils
, util-linux
, socat
, spice-gtk
, swtpm
, unzip
, wget
, xdg-user-dirs
, xrandr
, zsync
, OVMF
, OVMFFull
, quickemu
, curl
, testers
, installShellFiles
}:
let
  runtimePaths = [
    cdrtools
    curl
    gnugrep
    gnused
    jq
    lsb-release
    procps
    python3
    qemu
    socat
    swtpm
    unzip
    usbutils
    util-linux
    wget
    xdg-user-dirs
    xrandr
    zsync
  ];
in

stdenv.mkDerivation (finalAttrs : {
  pname = "quickemu";
  version = "4.9.3";

  src = fetchFromGitHub {
    owner = "quickemu-project";
    repo = "quickemu";
    rev = finalAttrs.version;
    hash = "sha256-/rByXtk107hq18VVPWf/4nX+hdYHsVrNVrTuC8yoCmw=";
  };

  postPatch = ''
    sed -i \
      -e '/OVMF_CODE_4M.secboot.fd/s|ovmfs=(|ovmfs=("${OVMFFull.firmware}","${OVMFFull.variables}" |' \
      -e '/OVMF_CODE_4M.fd/s|ovmfs=(|ovmfs=("${OVMF.firmware}","${OVMF.variables}" |' \
      -e '/cp "''${VARS_IN}" "''${VARS_OUT}"/a chmod +w "''${VARS_OUT}"' \
      -e 's/Icon=.*qemu.svg/Icon=qemu/' \
      quickemu
  '';

  nativeBuildInputs = [ makeWrapper installShellFiles ];

  installPhase = ''
    runHook preInstall

    installManPage docs/quickget.1 docs/quickemu.1 docs/quickemu_conf.1
    install -Dm755 -t "$out/bin" chunkcheck quickemu quickget windowskey

    # spice-gtk needs to be put in suffix so that when virtualisation.spiceUSBRedirection
    # is enabled, the wrapped spice-client-glib-usb-acl-helper is used
    for f in chunkcheck quickget quickemu windowskey; do
      wrapProgram $out/bin/$f \
        --prefix PATH : "${lib.makeBinPath runtimePaths}" \
        --suffix PATH : "${lib.makeBinPath [ spice-gtk ]}"
    done

    runHook postInstall
  '';

  passthru.tests = testers.testVersion { package = quickemu; };

  meta = {
    description = "Quickly create and run optimised Windows, macOS and Linux desktop virtual machines";
    homepage = "https://github.com/quickemu-project/quickemu";
    mainProgram = "quickemu";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ fedx-sudo ];
  };
})
