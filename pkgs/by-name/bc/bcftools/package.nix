{
  lib,
  stdenv,
  fetchFromGitHub,
  autoreconfHook,
  htslib,
  zlib,
  bzip2,
  xz,
  curl,
  perl,
  python3,
  bash,
  versionCheckHook,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "bcftools";
  version = "1.22";

  src = fetchFromGitHub {
    owner = "samtools";
    repo = "bcftools";
    tag = finalAttrs.version;
    hash = "sha256-S+FuqjiOf38sAQKWYOixv/MlXGnuDmkx9z4Co/pk/eM=";
  };

  # The perl/python helper scripts go to `scripts` so that `out` does not depend on perl and python
  outputs = [
    "out"
    "scripts"
  ];

  nativeBuildInputs = [
    autoreconfHook
    perl
    python3
  ];

  buildInputs = [
    htslib
    zlib
    bzip2
    xz
    curl
    # Interpreters for the helper scripts' shebangs
    perl
    python3
  ];

  nativeCheckInputs = [
    htslib
  ];

  strictDeps = true;
  __structuredAttrs = true;

  makeFlags = [
    "HSTDIR=${htslib}"
    "prefix=$(out)"
    "CC=${stdenv.cc.targetPrefix}cc"
  ];

  preCheck = ''
    patchShebangs misc/
    patchShebangs test/
    sed -i -e 's|/bin/bash|${bash}/bin/bash|' test/test.pl
  '';

  postInstall = ''
    for f in "$out"/bin/*; do
      if [[ "$(basename "$f")" != bcftools ]]; then
        moveToOutput "bin/$(basename "$f")" "$scripts"
      fi
    done
  '';

  enableParallelBuilding = true;

  doCheck = true;

  nativeInstallCheckInputs = [
    versionCheckHook
  ];
  doInstallCheck = true;

  meta = {
    description = "Tools for manipulating BCF2/VCF/gVCF format, SNP and short indel sequence variants";
    license = lib.licenses.mit;
    homepage = "http://www.htslib.org/";
    platforms = lib.platforms.unix;
    maintainers = [ lib.maintainers.mimame ];
    mainProgram = "bcftools";
  };
})
