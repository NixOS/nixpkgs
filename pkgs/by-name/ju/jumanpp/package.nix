{
  lib,
  stdenv,
  fetchurl,
  fetchpatch,
  cmake,
  protobuf,
  libiconv,
}:

stdenv.mkDerivation rec {
  pname = "jumanpp";
  version = "2.0.0-rc4";

  src = fetchurl {
    url = "https://github.com/ku-nlp/${pname}/releases/download/v${version}/${pname}-${version}.tar.xz";
    sha256 = "sha256-qyy0mTBrH3y8OBIVXuTHIDV+AbQIvCIA7rzhbI2b8y8=";
  };

  nativeBuildInputs = [ cmake ];
  buildInputs = [ protobuf ] ++ lib.optional stdenv.hostPlatform.isDarwin libiconv;

  meta = with lib; {
    description = "Japanese morphological analyser using a recurrent neural network language model (RNNLM)";
    mainProgram = "jumanpp";
    longDescription = ''
      JUMAN++ is a new morphological analyser that considers semantic
      plausibility of word sequences by using a recurrent neural network
      language model (RNNLM).
    '';
    homepage = "https://nlp.ist.i.kyoto-u.ac.jp/index.php?JUMAN++";
    license = licenses.asl20;
    maintainers = with maintainers; [
      mt-caret
      footvaalvica
    ];
    platforms = platforms.all;
  };
}
