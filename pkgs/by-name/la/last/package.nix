{
  lib,
  stdenv,
  fetchFromGitLab,
  unzip,
  zlib,
  python3,
  parallel,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "last";
  version = "1654";

  src = fetchFromGitLab {
    owner = "mcfrith";
    repo = "last";
    tag = finalAttrs.version;
    hash = "sha256-IN9rNrlt3ARmV1WnS4abF9PNRcWkRnREo2HYAAO/IKk=";
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
    platforms = lib.platforms.x86_64 ++ [ "aarch64-darwin" ];
  };
})
