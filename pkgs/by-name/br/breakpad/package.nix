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

  src = fetchgit {
    url = "https://chromium.googlesource.com/breakpad/breakpad";
    rev = "v${finalAttrs.version}";
    hash = "sha256-yk+TSzjmAr9QMTYduKVe/Aizph/NNmSS385pvGJckiQ=";
  };

  buildInputs = [ zlib ];

  postUnpack = ''
    ln -s ${lss} $sourceRoot/src/third_party/lss
  '';

  meta = with lib; {
    description = "Open-source multi-platform crash reporting system";
    homepage = "https://chromium.googlesource.com/breakpad";
    license = licenses.bsd3;
    maintainers = with maintainers; [ berberman ];
    platforms = platforms.all;
  };
})
