{
  lib,
  stdenv,
  fetchFromGitHub,
  python3,
  srecord,
  gcc-arm-embedded,
}:

stdenv.mkDerivation (prev: {
  pname = "nitrokey-pro-firmware";
  version = "0.15";

  src = fetchFromGitHub {
    owner = "Nitrokey";
    # We don't use pname here but follow the patterns here instead
    # https://github.com/NixOS/nixpkgs/pull/240569#discussion_r1249055170
    repo = "nitrokey-pro-firmware";
    rev = "v${prev.version}";
    sha256 = "sha256-q+kbEOLA05xR6weAWDA1hx4fVsaN9UNKiOXGxPRfXuI=";
    fetchSubmodules = true;
  };

  postPatch = ''
    substituteInPlace build/gcc/dfu.mk \
      --replace-fail "git submodule update --init --recursive" "" \
      --replace-fail '$(shell git describe)' "v${prev.version}"

    patchShebangs dapboot/libopencm3/scripts
  '';

  nativeBuildInputs = [
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

  meta = with lib; {
    description = "Firmware for the Nitrokey Pro device";
    homepage = "https://github.com/Nitrokey/nitrokey-pro-firmware";
    license = licenses.gpl3Plus;
		maintainers = with maintainers; [ imadnyc jleightcap kiike rcoeurjoly ];
		platforms = [ "armv7l-linux" ];
  };
})

