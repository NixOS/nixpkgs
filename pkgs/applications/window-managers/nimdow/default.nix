{ lib, fetchFromGitHub, nimPackages, libX11, libXft, libXinerama }:
nimPackages.buildNimPackage rec {
  pname = "nimdow";
<<<<<<< HEAD

  version = "0.7.37";
=======
  version = "0.7.36";

>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)

  src = fetchFromGitHub {
    owner = "avahe-kellenberger";
    repo = pname;
    rev = "v${version}";
<<<<<<< HEAD
    hash = "sha256-930wDS0UW65QzpUHHOuM25oi/OhFmG0Q7N05ftu7XlI=";
  };


  buildInputs = with nimPackages; [ parsetoml x11 safeseq safeset libX11 libXft libXinerama ];
=======
    hash = "sha256-+36wxKgboOd3HvGnD555WySzJWGL39DaFXmIaFYtSN8=";
  };


  buildInputs = with nimPackages; [ parsetoml x11 safeset libX11 libXft libXinerama ];
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)

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
