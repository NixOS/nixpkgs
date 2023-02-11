{ lib
, stdenv
, fetchFromGitHub
, cmake
, zlib
}:

stdenv.mkDerivation {
  pname = "TandemAligner";
  version = "unstable-2022-09-17";

  src = fetchFromGitHub {
    owner = "seryrzu";
    repo = "tandem_aligner";
    rev = "ac6004f108ad20477045f4d0b037d96051a9df70";
    hash = "sha256-iMDj1HZ8LzmZckuAM3lbG3eSJSd/5JGVA6SBs7+AgX8=";
  };

  sourceRoot = "source/tandem_aligner";

  nativeBuildInputs = [ cmake ];

  buildInputs = [ zlib ];

  installPhase = ''
    runHook preInstall
    mkdir -p $out/bin
    cp src/projects/tandem_aligner/tandem_aligner $out/bin
    runHook postInstall
  '';

  doCheck = true;

  # adapted from target test_launch in Makefile
  checkPhase = ''
    runHook preCheck
    mkdir -p $TMPDIR/test_launch
    src/projects/tandem_aligner/tandem_aligner \
      --first $src/tandem_aligner/test_dataset/first.fasta \
      --second $src/tandem_aligner/test_dataset/second.fasta \
      -o $TMPDIR/test_launch \
      --debug
    grep -q "Thank you for using TandemAligner!" $TMPDIR/test_launch/tandem_aligner.log
    diff $TMPDIR/test_launch/cigar.txt $src/tandem_aligner/test_dataset/true_cigar.txt
    runHook postCheck
  '';

  meta = {
    description = "A parameter-free algorithm for sequence alignment";
    homepage = "https://github.com/seryrzu/tandem_aligner";
    license = lib.licenses.bsd3;
    maintainers = with lib.maintainers; [ amesgen ];
    platforms = lib.platforms.linux;
    mainProgram = "tandem_aligner";
  };
}
