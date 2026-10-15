{
  lib,
  stdenv,
  fetchurl,
  pkg-config,
  libatomic_ops,
  boehmgc,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "chase";
  version = "0.5.2";

  nativeBuildInputs = [ pkg-config ];
  buildInputs = [
    libatomic_ops
    boehmgc
  ];
  src = fetchurl {
    url = "mirror://debian/pool/main/c/chase/chase_${finalAttrs.version}.orig.tar.gz";
    sha256 = "68d95c2d4dc45553b75790fcea4413b7204a2618dff148116ca9bdb0310d737f";
  };

  doCheck = true;
  makeFlags = [
    "-e"
    "LIBS=-lgc"
  ];

  meta = {
    description = "Follow a symlink and print out its target file";
    longDescription = ''
      A commandline program that chases symbolic filesystems links to the original file
    '';
    homepage = "https://qa.debian.org/developer.php?login=rotty%40debian.org";
    license = lib.licenses.gpl2Plus;
    maintainers = [ lib.maintainers.polyrod ];
    platforms = lib.platforms.all;
    mainProgram = "chase";
  };
})
