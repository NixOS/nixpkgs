{
  lib,
  stdenv,
  fetchFromGitHub,
  wrapQtAppsHook,
  pkg-config,
  qmake,
  qtwayland,
  qtsvg,
  postgresql,
  cups,
  libxml2,
}:

stdenv.mkDerivation rec {
  pname = "pgmodeler";
  version = "1.1.3";

  src = fetchFromGitHub {
    owner = "pgmodeler";
    repo = "pgmodeler";
    rev = "v${version}";
    sha256 = "sha256-LDgRv7Todyy2pnE21Z0O5JQ6mE4ZO3THv6rfEWU66Cc=";
  };

  nativeBuildInputs = [
    pkg-config
    qmake
    wrapQtAppsHook
  ];
  qmakeFlags =
    [
      "pgmodeler.pro"
      "CONFIG+=release"
    ]
    ++ lib.optionals stdenv.isDarwin [
      "PGSQL_INC=${postgresql}/include"
      "PGSQL_LIB=${postgresql.lib}/lib/libpq.dylib"
      "XML_INC=${libxml2.dev}/include/libxml2"
      "XML_LIB=${libxml2.out}/lib/libxml2.dylib"
      "PREFIX=${placeholder "out"}/Applications/pgModeler.app/Contents"
    ];

  # todo: libpq would suffice here. Unfortunately this won't work, if one uses only postgresql.lib here.
  buildInputs =
    [
      postgresql
      qtsvg
    ]
    ++ lib.optionals stdenv.isLinux [ qtwayland ]
    ++ lib.optionals stdenv.isDarwin [
      cups
      libxml2
    ];

  postInstall = lib.optionalString stdenv.isDarwin ''
    mkdir -p $out/bin
    for item in pgmodeler pgmodeler-{cli,se,ch}
    do
      ln -s $out/Applications/pgModeler.app/Contents/MacOS/$item $out/bin
    done
  '';

  dontWrapQtApps = stdenv.isDarwin;

  meta = with lib; {
    description = "A database modeling tool for PostgreSQL";
    homepage = "https://pgmodeler.io/";
    license = licenses.gpl3;
    maintainers = [ maintainers.esclear ];
    platforms = platforms.unix;
  };
}
