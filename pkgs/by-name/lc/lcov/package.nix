{
  lib,
  stdenv,
  fetchFromGitHub,
  perl,
  python3,
  perlPackages,
  makeWrapper,
}:

let
  perlDeps = [
    perlPackages.CaptureTiny
    perlPackages.DateTime
    perlPackages.DateTimeFormatW3CDTF
    perlPackages.DevelCover
    perlPackages.GD
    perlPackages.JSONXS
    perlPackages.PathTools
  ] ++ lib.optionals (!stdenv.hostPlatform.isDarwin) [ perlPackages.MemoryProcess ];
in
stdenv.mkDerivation rec {
  pname = "lcov";
  version = "2.2";

  src = fetchFromGitHub {
    owner = "linux-test-project";
    repo = "lcov";
    rev = "v${version}";
    hash = "sha256-cZdDlOf3IgPQrUNl+wu6Gwecaj+r2xu0eqmlz67TeAI=";
  };

  nativeBuildInputs = [ makeWrapper ];

  buildInputs = [
    perl
    python3
  ];

  preBuild = ''
    patchShebangs bin/
    makeFlagsArray=(PREFIX=$out LCOV_PERL_PATH=$(command -v perl))
  '';

  postInstall = ''
    for f in "$out"/bin/{gen*,lcov,perl2lcov}; do
      wrapProgram "$f" --set PERL5LIB ${perlPackages.makeFullPerlPath perlDeps}
    done
  '';

  meta = {
    description = "Code coverage tool that enhances GNU gcov";

    longDescription = ''
      LCOV is an extension of GCOV, a GNU tool which provides information
      about what parts of a program are actually executed (i.e.,
      "covered") while running a particular test case.  The extension
      consists of a set of PERL scripts which build on the textual GCOV
      output to implement the following enhanced functionality such as
      HTML output.
    '';

    homepage = "https://github.com/linux-test-project/lcov";
    license = lib.licenses.gpl2Plus;

    maintainers = with lib.maintainers; [ dezgeg ];
    platforms = lib.platforms.all;
  };
}
