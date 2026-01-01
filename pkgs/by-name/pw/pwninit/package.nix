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
<<<<<<< HEAD
  version = "3.3.2";
=======
  version = "3.3.1";
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)

  src = fetchFromGitHub {
    owner = "io12";
    repo = "pwninit";
    rev = version;
<<<<<<< HEAD
    sha256 = "sha256-WKOndOkaKr+dUnx61LW6ZZxUFUESerjE5W6hgLA3n1o=";
=======
    sha256 = "sha256-tbZS7PdRFvO2ifoHA/w3cSPfqqHrLeLHAg6V8oG9gVE=";
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
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

<<<<<<< HEAD
  cargoHash = "sha256-KMvaKTNC84K6N0NAZizK9M1nP4rV4cfwlOTI/HidQYc=";
=======
  cargoHash = "sha256-N0vje5ZU7B++f71BJKwkEfpbInpermH241f6oP1/fQE=";
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)

  meta = {
    description = "Automate starting binary exploit challenges";
    mainProgram = "pwninit";
    homepage = "https://github.com/io12/pwninit";
    license = lib.licenses.mit;
    maintainers = [ lib.maintainers.scoder12 ];
    platforms = lib.platforms.all;
  };
}
