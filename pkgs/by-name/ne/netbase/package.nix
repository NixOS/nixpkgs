{
  lib,
  stdenv,
  fetchFromGitHub,
  byacc,
  clang,
  llvm,
  gnumake,
  bzip2,
  zlib,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "netbase";
  version = "0.1";

  src = fetchFromGitHub {
    owner = "littlefly365";
    repo = "Netbase";
    tag = "v${finalAttrs.version}";
    hash = "sha256-o/O3pqdYY3Q/ut7P7sbYaivlWJuwhhGmMrMBSPbslV4=";
  };

  strictDeps = true;

  nativeBuildInputs = [
    byacc
    clang
    llvm
    gnumake
  ];

  buildInputs = [
    bzip2
    zlib
  ];

  postPatch = ''
    substituteInPlace bin/ksh/Makefile \
      --replace-fail '$(pwd)' '$(CURDIR)'
  '';

  buildPhase = ''
    runHook preBuild
    make -f GNUmakefile -j$NIX_BUILD_CORES
    runHook postBuild
  '';

  installPhase = ''
    runHook preInstall

    mkdir -p $out/bin

    for dir in build/bin build/sbin build/usr.bin; do
      if [ -d "$dir" ]; then
        for prog in "$dir"/*; do
          [ -f "$prog" ] || continue
          install -m755 "$prog" "$out/bin/$(basename "$prog")"
        done
      fi
    done

    runHook postInstall
  '';

  meta = {
    description = "Port of NetBSD userland utilities";
    homepage = "https://github.com/littlefly365/Netbase";
    license = lib.licenses.bsd3;
    maintainers = with lib.maintainers; [ iamanaws ];
    platforms = lib.platforms.linux;
  };
})
