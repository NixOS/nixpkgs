{ lib, fetchFromGitHub, nimPackages, libX11, libXft, libXinerama }:
nimPackages.buildNimPackage rec {
  pname = "nimdow";

  version = "0.7.37";

  src = fetchFromGitHub {
    owner = "avahe-kellenberger";
    repo = pname;
    rev = "v${version}";
    hash = "sha256-930wDS0UW65QzpUHHOuM25oi/OhFmG0Q7N05ftu7XlI=";
  };


  buildInputs = with nimPackages; [ parsetoml x11 safeseq safeset libX11 libXft libXinerama ];

  postInstall = ''
    install -D config.default.toml $out/share/nimdow/config.default.toml
    install -D nimdow.desktop $out/share/applications/nimdow.desktop
  '';

  postPatch = ''
    substituteInPlace src/nimdowpkg/config/configloader.nim --replace "/usr/share/nimdow" "$out/share/nimdow"
  '';



  doCheck = true;

  meta = with lib;
    src.meta // {
      description = "Nim based tiling window manager";
      license = [ licenses.gpl2 ];
      maintainers = [ maintainers.marcusramberg ];
    };
}
