{ lib
, stdenv
, fetchFromGitHub
, writeText
, fontconfig
, libX11
, libXft
, libXinerama
, libXpm
, libXrender
, conf ? null
}:

stdenv.mkDerivation rec {
  pname = "shod";
  version = "2.4.0";

  src = fetchFromGitHub {
    owner = "phillbush";
    repo = "shod";
    rev = "v${version}";
    sha256 = "sha256-jrPuI3ADppqaJ2y9GksiJZZd4LtN1P5yjWwlf9VuYDc=";
  };

  buildInputs = [
    fontconfig
    libX11
    libXft
    libXinerama
    libXpm
    libXrender
  ];

  postPatch =
    let
      configFile =
        if lib.isDerivation conf || builtins.isPath conf
        then conf else writeText "config.h" conf;
    in
    lib.optionalString (conf != null) "cp ${configFile} config.h";

  makeFlags = [ "PREFIX=$(out)" ];

  meta = with lib; {
    description = "A mouse-based window manager that can tile windows inside floating containers";
    longDescription = ''
      shod is a multi-monitor floating reparenting X11 window manager that
      supports tiled and tabbed containers. shod sets no keybindings, reads no
      configuration, and works only via mouse with a given key modifier (Alt by
      default) and by responding to client messages sent by the shodc utility
      (shod's remote controller).
    '';
    homepage = "https://github.com/phillbush/shod";
    license = licenses.mit;
    maintainers = with maintainers; [ azahi ];
    platforms = platforms.unix;
  };
}
