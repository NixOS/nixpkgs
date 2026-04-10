{
  lib,
  stdenv,
  fetchgit,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "mdf2iso";
  version = "0.3.1";

  src = fetchgit {
    url = "https://salsa.debian.org/debian/mdf2iso";
    rev = "c6a5b588318d43bc8af986bbe48d0a06e92f4280";
    sha256 = "0xg43jlvrk8adfjgbjir15nxwcj0nhz4gxpqx7jdfvhg0kwliq0n";
  };

  meta = {
    description = "Small utility that converts MDF images to ISO format";
    homepage = finalAttrs.src.url;
    license = lib.licenses.gpl2Plus;
    platforms = lib.platforms.unix;
    maintainers = [ lib.maintainers.oxij ];
    mainProgram = "mdf2iso";
  };
})
