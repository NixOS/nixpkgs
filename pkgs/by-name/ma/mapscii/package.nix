{
  lib,
  fetchFromGitHub,
  buildNpmPackage,
}:
buildNpmPackage rec {
  pname = "mapscii";
  version = "0.3.1";

  src = fetchFromGitHub {
    owner = "rastapasta";
    repo = "mapscii";
    rev = "v${version}";
    hash = "sha256-IFVX3l2b3pu0nfMZebVix0mwHUvnE2NUNrB3+jr3G2Q=";
  };

  npmDepsHash = "sha256-w/gTRritttShxrj6n6RzjCVin6TjJl+o/sVoBafAM+0=";

  dontNpmBuild = true;

  # remove broken links to build tools
  postInstall = ''
    rm -r $out/lib/node_modules/mapscii/node_modules/.bin
  '';

  meta = with lib; {
    description = "Braille & ASCII world map renderer for your console";
    homepage = "https://github.com/rastapasta/mapscii";
    license = licenses.mit;
    maintainers = with maintainers; [ kinzoku ];
    mainProgram = "mapscii";
    platforms = platforms.all;
  };
}
