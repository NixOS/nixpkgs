{
  lib,
  stdenv,
  fetchurl,
}:

stdenv.mkDerivation rec {
  pname = "parse-cli-bin";
  version = "3.0.5";

  src = fetchurl {
    url = "https://github.com/ParsePlatform/parse-cli/releases/download/release_${version}/parse_linux";
    sha256 = "1iyfizbbxmr87wjgqiwqds51irgw6l3vm9wn89pc3zpj2zkyvf5h";
  };

<<<<<<< HEAD
  meta = {
    description = "Parse Command Line Interface";
    mainProgram = "parse";
    homepage = "https://parse.com";
    platforms = lib.platforms.linux;
    license = lib.licenses.bsd3;
=======
  meta = with lib; {
    description = "Parse Command Line Interface";
    mainProgram = "parse";
    homepage = "https://parse.com";
    platforms = platforms.linux;
    license = licenses.bsd3;
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
  };

  dontUnpack = true;

  installPhase = ''
    mkdir -p "$out/bin"
    cp "$src" "$out/bin/parse"
    chmod +x "$out/bin/parse"
  '';
}
