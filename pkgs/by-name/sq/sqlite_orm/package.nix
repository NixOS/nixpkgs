{ lib
, cmake
, fetchFromGitHub
, sqlite
, stdenv
}:
stdenv.mkDerivation (finalAttrs: {
  pname = "sqlite_orm";
  version = "1.8.2";

  src = fetchFromGitHub {
    owner = "fnc12";
    repo = "sqlite_orm";
    rev = "v${finalAttrs.version}";
    hash = "sha256-KqphGFcnR1Y11KqL7sxODSv7lEvcURdF6kLd3cg84kc=";
  };

  nativeBuildInputs = [
    cmake
  ];

  propagatedBuildInputs = [
    sqlite
  ];

  strictDeps = true;

  meta = with lib; {
    description = "Light header only SQLite ORM";
    homepage = "https://sqliteorm.com/";
    license = licenses.agpl3Only; # MIT license is commercial
    maintainers = with maintainers; [ ambroisie ];
    platforms = platforms.all;
  };
})
