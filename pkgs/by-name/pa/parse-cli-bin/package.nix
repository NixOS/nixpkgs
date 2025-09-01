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

  meta = with lib; {
    description = "Parse Command Line Interface";
    mainProgram = "parse";
    homepage = "https://parse.com";
    platforms = platforms.linux;
    license = licenses.bsd3;
  };

  dontUnpack = true;

  installPhase = ''
    mkdir -p "$out/bin"
    cp "$src" "$out/bin/parse"
    chmod +x "$out/bin/parse"
  '';
}
