{
  stdenv,
  fetchFromGitHub,
  lib,
  db,
  file,
  libnsl,
  writableTmpDirAsHomeHook,
  nix-update-script,
}:

stdenv.mkDerivation {
  pname = "re-Isearch";
  version = "2.20220925.4.0a-unstable-2025-09-11";

  src = fetchFromGitHub {
    owner = "re-Isearch";
    repo = "re-Isearch";
    rev = "26e44f3d66e7f19def909a8179f798f6a4fe0a8a";
    hash = "sha256-zAYdZrKx2xaNrPYS0BbNNA30TkMqqR8P7pCB/j9VBuY=";
  };

  patches = [
    # https://github.com/re-Isearch/re-Isearch/pull/12
    ./1001-Fix-resurcive-make-parallelism.patch
  ];

  postPatch = ''
    # Fix gcc-13 build due to missing <cstdint> include.
    # https://github.com/re-Isearch/re-Isearch/pull/13
    sed -e '1i #include <cstdint>' -i src/mmap.cxx

    # These flags are not supported on all architectures
    # https://github.com/re-Isearch/re-Isearch/issues/14
    substituteInPlace build/Makefile.ubuntu \
      --replace-fail "-msse2" "" \
      --replace-fail "-m64" ""
  '';

  nativeBuildInputs = [ writableTmpDirAsHomeHook ];

  buildinputs = [
    db
    file # libmagic
    libnsl
  ];

  makeFlags = [
    "CC=${stdenv.cc.targetPrefix}c++"
    "cc=${stdenv.cc.targetPrefix}cc"
    "LD=${stdenv.cc.targetPrefix}c++"
  ];

  preBuild = ''
    cd build
    makeFlagsArray+=(
      EXTRA_INC="-I${lib.getDev db}/include -I${lib.getDev file}/include"
      LD_PATH="-L../lib -L${db.out}/lib -L${file}/lib -L${libnsl}/lib"
    )
  '';

  # Handwritten Makefiles, doesn't properly ensure that libraries are built before they're used in linking
  # ld: cannot find -libUtils: No such file or directory
  # ld: cannot find -libLocal: No such file or directory
  enableParallelBuilding = false;

  installPhase = ''
    runHook preInstall

    mkdir -p $out/{bin,lib}

    cp ../bin/{Iindex,Isearch,Iutil,Idelete,zpresent,Iwatch,zipper} $out/bin
    cp ../lib/*.so $out/lib/

    runHook postInstall
  '';

  passthru.updateScript = nix-update-script {
    extraArgs = [ "--version=branch" ];
  };

  meta = {
    description = "Novel multimodal search and retrieval engine";
    homepage = "https://nlnet.nl/project/Re-iSearch/";
    license = lib.licenses.asl20;
    platforms = lib.platforms.linux;
    maintainers = [ lib.maintainers.astro ];
    teams = [ lib.teams.ngi ];
  };
}
