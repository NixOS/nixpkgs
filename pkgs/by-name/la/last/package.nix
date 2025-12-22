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
  version = "1650";

  src = fetchFromGitLab {
    owner = "mcfrith";
    repo = "last";
    rev = "refs/tags/${version}";
    hash = "sha256-5LfJK3bK4Td15tnn9NZ2J9sr/Rehmtl/ngzu4bRf1x0=";
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
