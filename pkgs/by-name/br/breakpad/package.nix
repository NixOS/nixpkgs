{
  lib,
  stdenv,
  fetchgit,
  zlib,
}:
let
  lss = fetchgit {
    url = "https://chromium.googlesource.com/linux-syscall-support";
    rev = "v2022.10.12";
    hash = "sha256-rF10v5oH4u9i9vnmFCVVl2Ew3h+QTiOsW64HeB0nRQU=";
  };
in
stdenv.mkDerivation (finalAttrs: {
  pname = "breakpad";
  version = "2024.02.16";

  __structuredAttrs = true;

  src = fetchgit {
    url = "https://chromium.googlesource.com/breakpad/breakpad";
    rev = "v${finalAttrs.version}";
    hash = "sha256-yk+TSzjmAr9QMTYduKVe/Aizph/NNmSS385pvGJckiQ=";
  };

  strictDeps = true;

  enableParallelBuilding = true;

  buildInputs = [ zlib ];

  configureFlags = lib.optionals stdenv.hostPlatform.isMusl [ "--disable-tools" ];

  postUnpack = ''
    ln -s ${lss} $sourceRoot/src/third_party/lss
  '';

  meta = {
    description = "Open-source multi-platform crash reporting system";
    homepage = "https://chromium.googlesource.com/breakpad";
    license = lib.licenses.bsd3;
    maintainers = with lib.maintainers; [ berberman ];
    platforms = lib.platforms.all;
  };
})
