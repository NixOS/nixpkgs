{
  lib,
  stdenv,
  fetchFromGitHub,
  rustPlatform,
  libkrun,
  passt,
  dhcpcd,
<<<<<<< HEAD
  socat,
  systemd,
  udev,
  pkg-config,
=======
  systemd,
  udev,
  pkg-config,
  procps,
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
  fex,
  writeShellApplication,
  coreutils,
  makeBinaryWrapper,
<<<<<<< HEAD
  nix-update-script,
=======
# TODO: Enable again when sommelier is not broken.
# For now, don't give false impression of sommelier being supported.
# sommelier,
# withSommelier ? false,
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
}:
let
  # TODO: Setup setuid wrappers.
  # E.g. FEX needs fusermount for rootfs functionality
  initScript = writeShellApplication {
    name = "muvm-init";
    runtimeInputs = [
      coreutils
    ];
    text = ''
<<<<<<< HEAD
      if [[ -f /etc/NIXOS ]]; then
        ln -s /run/muvm-host/run/current-system /run/current-system
        if [[ -d /run/muvm-host/run/opengl-driver ]]; then
           ln -s /run/muvm-host/run/opengl-driver /run/opengl-driver
        fi
      fi
    '';
  };
=======
      if [[ ! -f /etc/NIXOS ]]; then exit; fi

      ln -s /run/muvm-host/run/current-system /run/current-system
      # Only create the symlink if that path exists on the host and is a directory.
      if [[ -d /run/muvm-host/run/opengl-driver ]]; then ln -s /run/muvm-host/run/opengl-driver /run/opengl-driver; fi
    '';
  };
  binPath = [
    dhcpcd
    passt
    (placeholder "out")
  ]
  ++ lib.optionals stdenv.hostPlatform.isAarch64 [ fex ];
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
  wrapArgs = lib.escapeShellArgs [
    "--prefix"
    "PATH"
    ":"
<<<<<<< HEAD
    (lib.makeBinPath (
      [
        dhcpcd
        passt
        socat
        (placeholder "out")
      ]
      ++ lib.optionals stdenv.hostPlatform.isAarch64 [ fex ]
    ))
=======
    (lib.makeBinPath binPath)
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
    "--add-flags"
    "--execute-pre=${lib.getExe initScript}"
  ];
in
<<<<<<< HEAD
rustPlatform.buildRustPackage (finalAttrs: {
  pname = "muvm";
  version = "0.5.0";
=======
rustPlatform.buildRustPackage rec {
  pname = "muvm";
  version = "0.4.1";
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)

  src = fetchFromGitHub {
    owner = "AsahiLinux";
    repo = "muvm";
<<<<<<< HEAD
    tag = "muvm-${finalAttrs.version}";
    hash = "sha256-k3Jj/Tzu5ZfnADMiVG7pAPqosrkZvhmehi0NMbyudN0=";
  };

  cargoHash = "sha256-jFNyQD2Hf1K5+wHDRD2WG70IJfZbL+hT/gtjeUnt5Mk=";
=======
    rev = "muvm-${version}";
    hash = "sha256-1XPhVEj7iqTxdWyYwNk6cbb9VRGuhpvvowYDPJb1cWU=";
  };

  cargoHash = "sha256-fkvdS0c1Ib8Kto44ou06leXy731cpMHXevyFR5RROt4=";
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)

  postPatch = ''
    substituteInPlace crates/muvm/src/guest/bin/muvm-guest.rs \
      --replace-fail "/usr/lib/systemd/systemd-udevd" "${systemd}/lib/systemd/systemd-udevd"
<<<<<<< HEAD
=======

    substituteInPlace crates/muvm/src/monitor.rs \
      --replace-fail "/sbin/sysctl" "${lib.getExe' procps "sysctl"}"
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
  ''
  # Only patch FEX path if we're aarch64, otherwise we don't want the derivation to pull in FEX in any way
  + lib.optionalString stdenv.hostPlatform.isAarch64 ''
    substituteInPlace crates/muvm/src/guest/mount.rs \
      --replace-fail "/usr/share/fex-emu" "${fex}/share/fex-emu"
  '';

  nativeBuildInputs = [
    rustPlatform.bindgenHook
    makeBinaryWrapper
    pkg-config
  ];

  buildInputs = [
    (libkrun.override {
      withBlk = true;
      withGpu = true;
      withNet = true;
    })
    udev
  ];

  postFixup = ''
    wrapProgram $out/bin/muvm ${wrapArgs}
  '';

<<<<<<< HEAD
  passthru = {
    updateScript = nix-update-script { };
  };

=======
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
  meta = {
    description = "Run programs from your system in a microVM";
    homepage = "https://github.com/AsahiLinux/muvm";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [
      RossComputerGuy
      nrabulinski
    ];
    inherit (libkrun.meta) platforms;
    mainProgram = "muvm";
  };
<<<<<<< HEAD
})
=======
}
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
