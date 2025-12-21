{
  lib,
  stdenv,
  fetchFromGitHub,
  rustPlatform,
  libkrun,
  passt,
  dhcpcd,
  systemd,
  udev,
  pkg-config,
  fex,
  writeShellApplication,
  coreutils,
  makeBinaryWrapper,
  nix-update-script,
# TODO: Enable again when sommelier is not broken.
# For now, don't give false impression of sommelier being supported.
# sommelier,
# withSommelier ? false,
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
  wrapArgs = lib.escapeShellArgs [
    "--prefix"
    "PATH"
    ":"
    (lib.makeBinPath binPath)
    "--add-flags"
    "--execute-pre=${lib.getExe initScript}"
  ];
in
rustPlatform.buildRustPackage (finalAttrs: {
  pname = "muvm";
  version = "0.5.0";

  src = fetchFromGitHub {
    owner = "AsahiLinux";
    repo = "muvm";
    tag = "muvm-${finalAttrs.version}";
    hash = "sha256-k3Jj/Tzu5ZfnADMiVG7pAPqosrkZvhmehi0NMbyudN0=";
  };

  cargoHash = "sha256-jFNyQD2Hf1K5+wHDRD2WG70IJfZbL+hT/gtjeUnt5Mk=";

  postPatch = ''
    substituteInPlace crates/muvm/src/guest/bin/muvm-guest.rs \
      --replace-fail "/usr/lib/systemd/systemd-udevd" "${systemd}/lib/systemd/systemd-udevd"
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

  passthru = {
    updateScript = nix-update-script { };
  };

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
})
