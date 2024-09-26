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

  version = "0-unstable-2024-04-06";

  src = fetchFromGitHub {
    owner = "geoffreybennett";
    repo = "scarlett2";
    rev = "1c262bcac11bceb6da8334b8f5b56d3c9331bfc8";
    hash = "sha256-yhmXVfys300NwZ8UJ7WvOyNkGP3OkIVoRaToF+SenQA=";
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
    description = "Scarlett2 Firmware Management Utility for Scarlett 2nd, 3rd, and 4th Gen, Clarett USB, and Clarett+ interfaces";
    homepage = "https://github.com/geoffreybennett/scarlett2";
    license = lib.licenses.gpl3Only;
    maintainers = with lib.maintainers; [ squalus ];
    mainProgram = "scarlett2";
  };

}
