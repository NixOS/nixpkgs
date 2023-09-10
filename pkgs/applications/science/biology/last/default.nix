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
  version = "1471";

  src = fetchFromGitLab {
    owner = "mcfrith";
    repo = "last";
    rev = "refs/tags/${version}";
    hash = "sha256-HQ2C7SFfJS6TOJZUm6szhu+hMm41BnH8A7DZE5yh9fM=";
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
