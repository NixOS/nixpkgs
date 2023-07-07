{ lib, fetchFromGitHub, nimPackages, libX11, libXft, libXinerama }:
nimPackages.buildNimPackage rec {
  pname = "nimdow";
  version = "0.7.36";


  src = fetchFromGitHub {
    owner = "avahe-kellenberger";
    repo = pname;
    rev = "v${version}";
    hash = "sha256-+36wxKgboOd3HvGnD555WySzJWGL39DaFXmIaFYtSN8=";
  };


  buildInputs = with nimPackages; [ parsetoml x11 safeset libX11 libXft libXinerama ];

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
