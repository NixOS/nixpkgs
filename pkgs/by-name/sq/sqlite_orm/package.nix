{
  lib,
  cmake,
  fetchFromGitHub,
  sqlite,
  stdenv,
}:
stdenv.mkDerivation (finalAttrs: {
  pname = "sqlite_orm";
  version = "1.9.1";

  src = fetchFromGitHub {
    owner = "fnc12";
    repo = "sqlite_orm";
    rev = "v${finalAttrs.version}";
    hash = "sha256-tlmUYHH0V4qsKSTdrg/OrS9eOEseIDAIU/HN8YK36go=";
  };

  nativeBuildInputs = [
    cmake
  ];

  propagatedBuildInputs = [
    sqlite
  ];

  strictDeps = true;

<<<<<<< HEAD
  meta = {
    description = "Light header only SQLite ORM";
    homepage = "https://sqliteorm.com/";
    license = lib.licenses.agpl3Only; # MIT license is commercial
    maintainers = with lib.maintainers; [ ambroisie ];
    platforms = lib.platforms.all;
=======
  meta = with lib; {
    description = "Light header only SQLite ORM";
    homepage = "https://sqliteorm.com/";
    license = licenses.agpl3Only; # MIT license is commercial
    maintainers = with maintainers; [ ambroisie ];
    platforms = platforms.all;
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
  };
})
