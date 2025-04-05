{
  stdenv,
  fetchFromGitHub,
  lib,
  db,
  file,
  libnsl,
}:

stdenv.mkDerivation (finalAttr: {
  pname = "re-Isearch";
  version = "2.20220925.4.0a-unstable-2025-03-16";

  src = fetchFromGitHub {
    owner = "re-Isearch";
    repo = "re-Isearch";
    rev = "56e0dfbe7468881b3958ca8e630f41a5354e9873";
    sha256 = "sha256-tI75D02/sFEkHDQX/BpDlu24WNP6Qh9G0MIfEvs8npM=";
  };

  patches = [ ./0001-fix-JsonHitTable-undefined-reference.patch ];

  postPatch = ''
    # Fix gcc-13 build due to missing <cstdint> include.
    sed -e '1i #include <cstdint>' -i src/mmap.cxx
  '';

  buildinputs = [
    db
    file # libmagic
    libnsl
  ];

  makeFlags = [
    "CC=g++"
    "cc=gcc"
    "LD=g++"
  ];

  preBuild = ''
    cd build
    export HOME="$TMPDIR" # wants to write to HOME
    make clean # clean up pre-built objects in the source
    makeFlagsArray+=(
      EXTRA_INC="-I${db.dev}/include -I${lib.getDev file}/include"
      LD_PATH="-L../lib -L${db.out}/lib -L${file}/lib -L${libnsl}/lib"
    )
  '';

  preInstall = ''
    mkdir -p $out/{bin,lib}
  '';

  installPhase = ''
    runHook preInstall

    mkdir -p $out/{bin,lib}

    cp ../bin/{Iindex,Isearch,Iutil,Idelete,zpresent,Iwatch,zipper} $out/bin
    cp ../lib/*.so $out/lib/

    runHook postInstall
  '';

  meta = {
    description = "Novel multimodal search and retrieval engine";
    homepage = "https://github.com/re-Isearch/";
    license = lib.licenses.asl20;
    maintainers = [ lib.maintainers.astro ] ++ lib.teams.ngi.members;
  };
})
