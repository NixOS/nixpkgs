{
  lib,
  stdenv,
  fetchFromGitHub,
  minizip,
  python3,
  zlib,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "libxlsxwriter";
  version = "1.2.3";

  src = fetchFromGitHub {
    owner = "jmcnamara";
    repo = "libxlsxwriter";
    tag = "v${finalAttrs.version}";
    hash = "sha256-1FUJLsnx0ZNTT66sK7/gbZVo6Se85nbYvtEyoxeOHTI=";
  };

  buildInputs = [
    minizip
    zlib
  ];

  makeFlags = [
    "PREFIX=${placeholder "out"}"
    "USE_SYSTEM_MINIZIP=1"
  ];

  # TEST 428/429 worksheet:worksheet_table15 *** buffer overflow detected ***: terminated
  hardeningDisable = [ "fortify3" ];

  doCheck = true;

  nativeCheckInputs = [
    python3.pkgs.pytest
  ];

  checkTarget = "test";

  meta = {
    description = "C library for creating Excel XLSX files";
    homepage = "https://libxlsxwriter.github.io/";
    changelog = "https://github.com/jmcnamara/libxlsxwriter/blob/${finalAttrs.src.tag}/Changes.txt";
    license = lib.licenses.bsd2;
    maintainers = with lib.maintainers; [ dotlambda ];
    platforms = lib.platforms.unix;
  };
})
