{ lib
, stdenv
, fetchFromGitHub
, wrapQtAppsHook
, pkg-config
, qmake
, qtwayland
, qtsvg
, postgresql
}:

stdenv.mkDerivation rec {
  pname = "pgmodeler";
<<<<<<< HEAD
  version = "1.0.5";
=======
  version = "1.0.3";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)

  src = fetchFromGitHub {
    owner = "pgmodeler";
    repo = "pgmodeler";
    rev = "v${version}";
<<<<<<< HEAD
    sha256 = "sha256-Wl4MKsZhn5FKEhsezt+j8qpZs+KNHaQrWQ8x7y51MNE=";
=======
    sha256 = "sha256-ZlIz+7YyER0/wQEkEe8XHYHcLK4vu09v1zkDrIgR/Dc=";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
  };

  nativeBuildInputs = [ pkg-config qmake wrapQtAppsHook ];
  qmakeFlags = [ "pgmodeler.pro" "CONFIG+=release" ];

  # todo: libpq would suffice here. Unfortunately this won't work, if one uses only postgresql.lib here.
  buildInputs = [ postgresql qtsvg qtwayland ];

  meta = with lib; {
    description = "A database modeling tool for PostgreSQL";
    homepage = "https://pgmodeler.io/";
    license = licenses.gpl3;
    maintainers = [ maintainers.esclear ];
    platforms = platforms.linux;
  };
}
