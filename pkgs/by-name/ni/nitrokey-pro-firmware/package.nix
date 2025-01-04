{
  lib,
  stdenv,
  fetchFromGitHub,
  writeShellScriptBin,
  python3,
  srecord,
  gcc-arm-embedded,
}:

let
  version = "0.15";

  # The firmware version is pulled from `git` so we stub it here to avoid pulling the whole program.
  fakeGit = writeShellScriptBin "git" ''
    echo "${version}.nitrokey"
  '';

in

stdenv.mkDerivation {
  pname = "nitrokey-pro-firmware";
  inherit version;
  src = fetchFromGitHub {
    owner = "Nitrokey";
    repo = "nitrokey-pro-firmware";
    rev = "v${version}";
    hash = "sha256-q+kbEOLA05xR6weAWDA1hx4fVsaN9UNKiOXGxPRfXuI=";
    fetchSubmodules = true;
  };

  postPatch = ''
    patchShebangs dapboot/libopencm3/scripts
  '';

  nativeBuildInputs = [
    fakeGit
    gcc-arm-embedded
    python3
    srecord
  ];

  installPhase = ''
    runHook preInstall
    install -D build/gcc/bootloader.hex $out/bootloader.hex
    install -D build/gcc/nitrokey-pro-firmware.hex $out/firmware.hex
    runHook postInstall
  '';

  meta = {
    description = "Firmware for the Nitrokey Pro device";
    homepage = "https://github.com/Nitrokey/nitrokey-pro-firmware";
    license = lib.licenses.gpl3Plus;
    maintainers = with lib.maintainers; [
      imadnyc
      kiike
      amerino
    ];
    platforms = lib.platforms.unix;
  };
}
