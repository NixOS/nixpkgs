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
    rev = "a81d62812903cddde15f6d84d07152802cab10b2";
    hash = "sha256-r1Wj9cq8+HwXOrC5OIsC8D0XuN8WpqvZPdPWAH1Ohfs=";
  };

in
stdenv.mkDerivation {

  pname = "scarlett2";

  version = "1.0";

  src = fetchFromGitHub {
    owner = "geoffreybennett";
    repo = "scarlett2";
    rev = "1.0";
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
    maintainers = [ ];
    mainProgram = "scarlett2";
  };

}
