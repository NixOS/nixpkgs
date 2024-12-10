{
  lib,
  stdenv,
  fetchFromGitHub,
  buildPythonApplication,
  pem,
  pyside6,
  twisted,
  certifi,
  qt6,
  appnope,
  enableGUI ? true,
}:

buildPythonApplication rec {
  pname = "syncplay";
  version = "1.7.2";

  format = "other";

  src = fetchFromGitHub {
    owner = "Syncplay";
    repo = "syncplay";
    rev = "v${version}";
    sha256 = "sha256-PERPE6141LXmb8fmW17Vu54Unpf9vEK+ahm6q1byRTU=";
  };

  patches = [
    ./trusted_certificates.patch
  ];

  buildInputs = lib.optionals enableGUI [ (if stdenv.isLinux then qt6.qtwayland else qt6.qtbase) ];
  propagatedBuildInputs =
    [
      certifi
      pem
      twisted
    ]
    ++ twisted.optional-dependencies.tls
    ++ lib.optional enableGUI pyside6
    ++ lib.optional (stdenv.isDarwin && enableGUI) appnope;
  nativeBuildInputs = lib.optionals enableGUI [ qt6.wrapQtAppsHook ];

  makeFlags = [
    "DESTDIR="
    "PREFIX=$(out)"
  ];

  postFixup = lib.optionalString enableGUI ''
    wrapQtApp $out/bin/syncplay
  '';

  meta = with lib; {
    homepage = "https://syncplay.pl/";
    description = "Free software that synchronises media players";
    license = licenses.asl20;
    platforms = platforms.linux ++ platforms.darwin;
    maintainers = with maintainers; [
      assistant
      Enzime
    ];
  };
}
