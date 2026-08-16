{
  lib,
  stdenv,
  fetchFromGitHub,
  autoreconfHook,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "metamath";
  version = "0.198";

  nativeBuildInputs = [ autoreconfHook ];

  src = fetchFromGitHub {
    owner = "metamath";
    repo = "metamath-exe";
    rev = "v${finalAttrs.version}";
    sha256 = "sha256-Cg1dgz+uphDlGhKH3mTywtAccWinC5+pwNv4TB3YAnI=";
  };

  meta = {
    description = "Interpreter for the metamath proof language";
    mainProgram = "metamath";
    longDescription = ''
      The metamath program is an ASCII-based ANSI C program with a command-line
      interface. It was used (along with mmj2) to build and verify the proofs
      in the Metamath Proof Explorer, and it generated its web pages. The *.mm
      ASCII databases (set.mm and others) are also included in this derivation.
    '';
    homepage = "https://us.metamath.org";
    downloadPage = "https://us.metamath.org/#downloads";
    license = lib.licenses.gpl2Plus;
    maintainers = [ lib.maintainers.taneb ];
    platforms = lib.platforms.all;
  };
})
