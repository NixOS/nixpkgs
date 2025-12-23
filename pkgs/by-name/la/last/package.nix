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
  version = "1648";

  src = fetchFromGitLab {
    owner = "mcfrith";
    repo = "last";
    rev = "refs/tags/${version}";
    hash = "sha256-U1FGP6jzB36HLwTFKm/VMZWPPjo6mVuV/ePhGIkQgpg=";
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
