{
  lib,
  stdenv,
  fetchurl,
  pkg-config,
  libatomic_ops,
  boehmgc,
}:

stdenv.mkDerivation rec {
  pname = "chase";
  version = "0.5.2";

  nativeBuildInputs = [ pkg-config ];
  buildInputs = [
    libatomic_ops
    boehmgc
  ];
  src = fetchurl {
    url = "mirror://debian/pool/main/c/chase/chase_${version}.orig.tar.gz";
    sha256 = "68d95c2d4dc45553b75790fcea4413b7204a2618dff148116ca9bdb0310d737f";
  };

  doCheck = true;
  makeFlags = [
    "-e"
    "LIBS=-lgc"
  ];

<<<<<<< HEAD
  meta = {
=======
  meta = with lib; {
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
    description = "Follow a symlink and print out its target file";
    longDescription = ''
      A commandline program that chases symbolic filesystems links to the original file
    '';
    homepage = "https://qa.debian.org/developer.php?login=rotty%40debian.org";
<<<<<<< HEAD
    license = lib.licenses.gpl2Plus;
    maintainers = [ lib.maintainers.polyrod ];
    platforms = lib.platforms.all;
=======
    license = licenses.gpl2Plus;
    maintainers = [ maintainers.polyrod ];
    platforms = platforms.all;
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
    mainProgram = "chase";
  };
}
