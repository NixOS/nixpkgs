{
  lib,
  fetchFromGitHub,
  rustPlatform,
  openssl,
  elfutils,
  makeBinaryWrapper,
  pkg-config,
  xz,
}:

rustPlatform.buildRustPackage rec {
  pname = "pwninit";
  version = "3.3.1";

  src = fetchFromGitHub {
    owner = "io12";
    repo = "pwninit";
    rev = version;
    sha256 = "sha256-tbZS7PdRFvO2ifoHA/w3cSPfqqHrLeLHAg6V8oG9gVE=";
  };

  buildInputs = [
    openssl
    xz
  ];
  nativeBuildInputs = [
    pkg-config
    makeBinaryWrapper
  ];
  postInstall = ''
    wrapProgram $out/bin/pwninit \
      --prefix PATH : "${lib.getBin elfutils}/bin"
  '';
  doCheck = false; # there are no tests to run

  cargoHash = "sha256-N0vje5ZU7B++f71BJKwkEfpbInpermH241f6oP1/fQE=";

  meta = {
    description = "Automate starting binary exploit challenges";
    mainProgram = "pwninit";
    homepage = "https://github.com/io12/pwninit";
    license = lib.licenses.mit;
    maintainers = [ lib.maintainers.scoder12 ];
    platforms = lib.platforms.all;
  };
}
