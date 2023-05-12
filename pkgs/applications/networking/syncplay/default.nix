{ lib, fetchFromGitHub, buildPythonApplication, pyside2, twisted, certifi, qt5, enableGUI ? true }:

buildPythonApplication rec {
  pname = "syncplay";
  version = "1.7.0";

  format = "other";

  src = fetchFromGitHub {
    owner = "Syncplay";
    repo = "syncplay";
    rev = "v${version}";
    sha256 = "sha256-Te81yOv3D6M6aMfC5XrM6/I6BlMdlY1yRk1RRJa9Mxg=";
  };

  buildInputs = lib.optionals enableGUI [ qt5.qtwayland ];
  propagatedBuildInputs = [ twisted certifi ]
    ++ twisted.optional-dependencies.tls
    ++ lib.optional enableGUI pyside2;
  nativeBuildInputs = lib.optionals enableGUI [ qt5.wrapQtAppsHook ];

  makeFlags = [ "DESTDIR=" "PREFIX=$(out)" ];

  postFixup = lib.optionalString enableGUI ''
    wrapQtApp $out/bin/syncplay
  '';

  meta = with lib; {
    homepage = "https://syncplay.pl/";
    description = "Free software that synchronises media players";
    license = licenses.asl20;
    platforms = platforms.linux;
    maintainers = with maintainers; [ Enzime ];
  };
}
