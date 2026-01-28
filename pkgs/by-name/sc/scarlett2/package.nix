{
  stdenv,
  fetchFromGitHub,
  alsa-lib,
  openssl,
  pkg-config,
  lib,
  unstableGitUpdater,
}:

let

  firmwareSrc = fetchFromGitHub {
    owner = "geoffreybennett";
    repo = "scarlett2-firmware";
    rev = "f628dfb4d2e874b2078dbb43e8c1d59dd6553dd1";
    hash = "sha256-s61eyS47SuIbK9KR59XxHpybvl9tHFWPLkpHmdqwO24=";
  };

in
stdenv.mkDerivation {

  pname = "scarlett2";

  version = "1.0-unstable-2026-01-27";

  src = fetchFromGitHub {
    owner = "geoffreybennett";
    repo = "scarlett2";
    rev = "f7a73c7237856e5a50d1fb24408c6c1f83b25db3";
    hash = "sha256-GfWfIOQfH5SoBdExIT1p/OHXJG2pwzTW/RS8Rs4QSGQ=";
  };

  buildInputs = [
    alsa-lib
    openssl
  ];

  nativeBuildInputs = [ pkg-config ];

  preBuild = ''
    makeFlagsArray+=( PREFIX=$out )
  '';

  passthru.updateScript = unstableGitUpdater { };

  # the program expects to find firmware files in a directory called "firmware" relative to the resolved path of the binary
  postInstall = ''
    mkdir -p $out/share
    mv $out/bin/scarlett2 $out/share
    ln -s $out/share/scarlett2 $out/bin/scarlett2
    ln -s ${firmwareSrc}/firmware $out/share/firmware
  '';

  meta = {
    description = "Firmware Management Utility for Scarlett 2nd, 3rd, and 4th Gen, Clarett USB, and Clarett+ interfaces";
    homepage = "https://github.com/geoffreybennett/scarlett2";
    license = lib.licenses.gpl3Only;
    maintainers = with lib.maintainers; [ squalus ];
    mainProgram = "scarlett2";
  };

}
