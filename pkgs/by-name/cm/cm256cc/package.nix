{
  lib,
  stdenv,
  fetchFromGitHub,
  cmake,
  boost,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "cm256cc";
  version = "1.1.2";

  src = fetchFromGitHub {
    owner = "f4exb";
    repo = "cm256cc";
    rev = "v${finalAttrs.version}";
    hash = "sha256-sAbc8yieGolV8lowiwFBVsd1HNYl1oxJwIw1kc3iI3U=";
  };

  nativeBuildInputs = [ cmake ];
  buildInputs = [ boost ];

  # https://github.com/f4exb/cm256cc/issues/16
  postPatch = ''
    substituteInPlace libcm256cc.pc.in \
      --replace '$'{exec_prefix}/@CMAKE_INSTALL_LIBDIR@ @CMAKE_INSTALL_FULL_LIBDIR@
  '';

  meta = {
    description = "Fast GF(256) Cauchy MDS Block Erasure Codec in C++";
    homepage = "https://github.com/f4exb/cm256cc";
    platforms = lib.platforms.unix;
    maintainers = with lib.maintainers; [
      aciceri
      alkeryn
    ];
    license = lib.licenses.gpl3;
  };
})
