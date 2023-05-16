{ lib
, stdenv
, fetchFromGitLab
, unzip
, zlib
, python3
, parallel
}:

stdenv.mkDerivation rec {
  pname = "last";
<<<<<<< HEAD
  version = "1471";
=======
  version = "1453";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)

  src = fetchFromGitLab {
    owner = "mcfrith";
    repo = "last";
    rev = "refs/tags/${version}";
<<<<<<< HEAD
    hash = "sha256-HQ2C7SFfJS6TOJZUm6szhu+hMm41BnH8A7DZE5yh9fM=";
=======
    hash = "sha256-r8bWk1+weSyQ5QPGKKwdAzMkzh3DgzTUr5YCMUq5UUM=";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
  };

  nativeBuildInputs = [
    unzip
  ];

  buildInputs = [
    zlib
    python3
  ];

  makeFlags = [
    "prefix=${placeholder "out"}"
  ];

  postFixup = ''
    for f in $out/bin/parallel-* ; do
      sed -i 's|parallel |${parallel}/bin/parallel |' $f
    done
  '';

  meta = with lib; {
    description = "Genomic sequence aligner";
    homepage = "https://gitlab.com/mcfrith/last";
    license = licenses.gpl3Plus;
    maintainers = with maintainers; [ jbedo ];
    platforms = platforms.x86_64;
  };
}
