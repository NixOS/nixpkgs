{
  lib,
  stdenv,
  fetchFromGitHub,
}:
stdenv.mkDerivation rec {
  pname = "pdpmake";
  version = "2.0.3";

  src = fetchFromGitHub {
    owner = "rmyorston";
    repo = "pdpmake";
    rev = version;
    hash = "sha256-6lLYtBKZTmi+fBkCyDysJS1O37/Z6ir9hU3pX4X1VHQ=";
  };

  makeFlags = [ "PREFIX=$(out)" ];

  doCheck = true;
  checkTarget = "test";

  enableParallelBuilding = true;

  meta = {
    homepage = "https://github.com/rmyorston/pdpmake";
    description = "Public domain POSIX make";
    license = lib.licenses.unlicense;
    maintainers = with lib.maintainers; [ eownerdead ];
    mainProgram = "pdpmake";
    platforms = lib.platforms.all;
    badPlatforms = lib.platforms.darwin; # Requires `uimensat`
  };
}
