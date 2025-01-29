{
  lib,
  stdenv,
  fetchgit,
  fetchpatch,
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

  version = "2023.06.01";

  src = fetchgit {
    url = "https://chromium.googlesource.com/breakpad/breakpad";
    rev = "v${finalAttrs.version}";
    hash = "sha256-8AkC/8oX4OWAcV21laJ0AeMRB9G04rFc6UJFy7Wus4A=";
  };

  patches = [
    (fetchpatch {
      name = "gcc-14-fixes.patch";
      url = "https://github.com/google/breakpad/commit/898a997855168c0e6a689072fefba89246271a5d.patch";
      hash = "sha256-OxodMx7XfKiD9j6b8oFvloslYagSSpQn7BPdpMVOoDY=";
    })
  ];

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
