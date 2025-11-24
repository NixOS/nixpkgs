{
  lib,
  stdenv,
  fetchurl,
  cmake,
  protobuf,
  libiconv,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "jumanpp";
  version = "2.0.0-rc4";

  src = fetchurl {
    url = "https://github.com/ku-nlp/jumanpp/releases/download/v${finalAttrs.version}/jumanpp-${finalAttrs.version}.tar.xz";
    hash = "sha256-qyy0mTBrH3y8OBIVXuTHIDV+AbQIvCIA7rzhbI2b8y8=";
  };

  doCheck = true;

  nativeBuildInputs = [ cmake ];
  buildInputs = [ protobuf ] ++ lib.optional stdenv.hostPlatform.isDarwin libiconv;

  postPatch = ''
    substituteInPlace libs/pathie-cpp/CMakeLists.txt \
      --replace-fail "cmake_minimum_required(VERSION 3.1)" "cmake_minimum_required(VERSION 3.10)"
  '';

  meta = {
    description = "Japanese morphological analyser using a recurrent neural network language model (RNNLM)";
    mainProgram = "jumanpp";
    longDescription = ''
      JUMAN++ is a new morphological analyser that considers semantic
      plausibility of word sequences by using a recurrent neural network
      language model (RNNLM).
    '';
    homepage = "https://nlp.ist.i.kyoto-u.ac.jp/index.php?JUMAN++";
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [ mt-caret ];
    platforms = lib.platforms.all;
  };
})
