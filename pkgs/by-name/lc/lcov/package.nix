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
  version = "2.3.1";

  src = fetchFromGitHub {
    owner = "linux-test-project";
    repo = "lcov";
    rev = "v${version}";
    hash = "sha256-31318or9AQ7iyu9DNQEvf5jaDzrneOOqOXu0HF1eag4=";
  };

  nativeBuildInputs = [
    makeWrapper
    perl
  ];

  buildInputs = [
    perl
    python3
  ];

  strictDeps = true;

  preBuild = ''
    patchShebangs --build bin/{fix.pl,get_version.sh} tests/*/*
    patchShebangs --host bin/{gen*,lcov,perl2lcov}
    makeFlagsArray=(PREFIX=$out LCOV_PERL_PATH=${lib.getExe perl})
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
