{
  lib,
  stdenv,
  fetchFromGitLab,
  unzip,
  zlib,
  python3,
  parallel,
}:

stdenv.mkDerivation rec {
  pname = "last";
  version = "1651";

  src = fetchFromGitLab {
    owner = "mcfrith";
    repo = "last";
    tag = version;
    hash = "sha256-TAc9prYydX5XO31f6p5DD7XMxVbNOW9ROtB7Agd7t8c=";
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

  meta = {
    description = "Genomic sequence aligner";
    homepage = "https://gitlab.com/mcfrith/last";
    license = lib.licenses.gpl3Plus;
    maintainers = with lib.maintainers; [ jbedo ];
    platforms = lib.platforms.x86_64;
  };
}
