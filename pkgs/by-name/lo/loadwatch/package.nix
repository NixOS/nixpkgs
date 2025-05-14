{
  lib,
  stdenv,
  fetchFromSourcehut,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "loadwatch";
  version = "1.1-4-g868bd29";

  src = fetchFromSourcehut {
    owner = "~woffs";
    repo = "loadwatch";
    hash = "sha256-/4kfGdpYJWQyb7mRaVUpyQQC5VP96bDsBDfM3XhcJXw=";
    rev = finalAttrs.version;
  };

  makeFlags = [ "bindir=$(out)/bin" ];

  meta = {
    description = "Run a program using only idle cycles";
    license = lib.licenses.gpl2Only;
    maintainers = with lib.maintainers; [ woffs ];
    platforms = lib.platforms.all;
  };
})
