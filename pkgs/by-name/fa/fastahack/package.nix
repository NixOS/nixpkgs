{
  lib,
  stdenv,
  fetchFromGitHub,
  runCommand,
  fastahack,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "fastahack";
  version = "1.0.0";

  src = fetchFromGitHub {
    owner = "ekg";
    repo = "fastahack";
    rev = "refs/tags/v${finalAttrs.version}";
    hash = "sha256-SWu2iRwNgdhsn4sH9/3jPNG3+l1xFAHXPq5/ODVd4WY=";
  };

  installFlags = [ "PREFIX=${placeholder "out"}" ];

  passthru.tests = {
    simple = runCommand "${finalAttrs.pname}-test" { } ''
      mkdir $out
      cp ${fastahack.src}/tests/* $out
      grep -v ERROR <(${lib.getExe fastahack} $out/correct.fasta 2>&1)
      grep -v ERROR <(${lib.getExe fastahack} $out/crlf.fasta 2>&1)
      grep "ERROR: embedded newline " <(${lib.getExe fastahack} $out/embedded_newline.fasta 2>&1)
      grep "ERROR: mismatched line lengths" <(${lib.getExe fastahack} $out/mismatched_lines.fasta 2>&1)
      grep -v ERROR <(${lib.getExe fastahack} $out/trailing_newlines.fasta 2>&1)
    '';
  };

  meta = {
    description = "Utilities for indexing and sequence extraction from FASTA files";
    homepage = "https://github.com/ekg/fastahack";
    changelog = "https://github.com/ekg/fastahack/releases/tag/v${finalAttrs.version}";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ natsukium ];
    mainProgram = "fastahack";
    platforms = lib.platforms.unix;
  };
})
