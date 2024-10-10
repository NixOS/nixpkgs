{
  lib,
  stdenv,
  fetchFromGitHub,
  fetchpatch,
  rustPlatform,
  libkrun,
  makeWrapper,
  passt,
  dhcpcd,
  sommelier,
  systemd,
  udev,
  pkg-config,
  withSommelier ? false,
}:

rustPlatform.buildRustPackage rec {
  pname = "muvm";
  version = "0.2.0";

  src = fetchFromGitHub {
    owner = "AsahiLinux";
    repo = pname;
    rev = "muvm-${version}";
    hash = "sha256-eB60LjI1Qr85MPtQh0Fb5ihzBahz95tXaozNe8q6o3o=";
  };

  useFetchCargoVendor = true;
  cargoHash = "sha256-B3klydX4xlop0pZUzMoxMjeRV7ZqWfKY+LhL+wFS4kM=";

  postPatch = ''
    substituteAll crates/muvm/src/guest/bin/muvm-guest.rs \
      --replace-fail "/usr/lib/systemd/systemd-udevd" "${systemd}/lib/systemd/systemd-udevd"
  '';

  nativeBuildInputs = [
    rustPlatform.bindgenHook
    makeWrapper
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

  # Allow for sommelier to be disabled as it can cause problems.
  wrapArgs = [
    "--prefix PATH : ${
      lib.makeBinPath (
        lib.optional withSommelier sommelier
        ++ [
          dhcpcd
          passt
          (placeholder "out")
        ]
      )
    }"
  ];

  postFixup = ''
    wrapProgram $out/bin/muvm $wrapArgs
  '';

  meta = {
    description = "Run programs from your system in a microVM";
    homepage = "https://github.com/AsahiLinux/muvm";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ RossComputerGuy ];
    platforms = libkrun.meta.platforms;
    mainProgram = "muvm";
  };
}
