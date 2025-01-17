{
  lib,
  stdenv,
  fetchFromGitea,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "dev86";
  version = "1.0.1";

  src = fetchFromGitea {
    domain = "codeberg.org";
    owner = "jbruchon";
    repo = "dev86";
    tag = "v${finalAttrs.version}";
    hash = "sha256-xeOtESc0X7RZWCIpNZSHE8au9+opXwnHsAcayYLSX7w=";
  };

  makeFlags = [ "PREFIX=${placeholder "out"}" ];

  meta = {
    homepage = "https://codeberg.org/jbruchon/dev86";
    description = "C compiler, assembler and linker environment for the production of 8086 executables";
    license = lib.licenses.gpl2Plus;
    maintainers = with lib.maintainers; [
      AndersonTorres
      sigmasquadron
    ];
    platforms = lib.platforms.linux;
  };
})
