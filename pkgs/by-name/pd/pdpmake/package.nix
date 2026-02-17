{
  lib,
  stdenv,
  fetchFromGitHub,
}:
stdenv.mkDerivation (finalAttrs: {
  pname = "pdpmake";
  version = "2.0.4";

  src = fetchFromGitHub {
    owner = "rmyorston";
    repo = "pdpmake";
    rev = finalAttrs.version;
    hash = "sha256-ivRXZxm9RAWSmNfiV7BhVzVFsBKuMMpKjub8ADinYyc=";
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
})
