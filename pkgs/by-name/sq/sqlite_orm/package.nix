{
  lib,
  cmake,
  fetchFromGitHub,
  sqlite,
  stdenv,
}:
stdenv.mkDerivation (finalAttrs: {
  pname = "sqlite_orm";
  version = "1.9";

  src = fetchFromGitHub {
    owner = "fnc12";
    repo = "sqlite_orm";
    rev = "v${finalAttrs.version}";
    hash = "sha256-jgRCYOtCyXj2E5J3iYBffX2AyBwvhune+i4Pb2eCBrA=";
  };

  nativeBuildInputs = [
    cmake
  ];

  propagatedBuildInputs = [
    sqlite
  ];

  strictDeps = true;

  meta = {
    description = "Light header only SQLite ORM";
    homepage = "https://sqliteorm.com/";
    license = lib.licenses.agpl3Only; # MIT license is commercial
    maintainers = with lib.maintainers; [ ambroisie ];
    platforms = lib.platforms.all;
  };
})
