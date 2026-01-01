{
  lib,
  symlinkJoin,
  fira-mono,
  fira-sans,
}:

<<<<<<< HEAD
symlinkJoin {
  pname = "fira";
  inherit (fira-sans) version;
=======
symlinkJoin rec {
  pname = "fira";
  inherit (fira-sans) version;
  name = "${pname}-${version}";
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)

  paths = [
    fira-mono
    fira-sans
  ];

  meta = {
    description = "Font family including Fira Sans and Fira Mono";
<<<<<<< HEAD
    homepage = "https://carrois.com/fira/";
=======
    homepage = "https://bboxtype.com/fira/";
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
    license = lib.licenses.ofl;
    platforms = lib.platforms.all;
  };
}
