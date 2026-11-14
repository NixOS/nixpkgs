{
  lib,
  stdenv,
  fetchFromGitHub,
  perl,
  python3,
  perlPackages,
  makeWrapper,
  versionCheckHook,
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
  ]
  ++ lib.optionals (!stdenv.hostPlatform.isDarwin) [ perlPackages.MemoryProcess ];
in
stdenv.mkDerivation (finalAttrs: {
  pname = "lcov";
  version = "2.6";

  src = fetchFromGitHub {
    owner = "linux-test-project";
    repo = "lcov";
    tag = "v${finalAttrs.version}";
    hash = "sha256-RPReVaxL8Ug+Vu7DE0yF5wtwgcxzzfxMNPXMO6ye68c=";
  };

  nativeBuildInputs = [
    makeWrapper
    perl
    # builds the man pages and HTML documentation
    (python3.withPackages (ps: [
      ps.sphinx
      ps.sphinx-rtd-theme
    ]))
  ];

  buildInputs = [
    perl
    python3
  ];

  strictDeps = true;

  makeFlags = [
    "PREFIX=$(out)"
    "VERSION=${finalAttrs.version}"
    "RELEASE=1"
  ];

  preBuild = ''
    # the build of the XS extension loads lcovutil.pm
    export PERL5LIB="${perlPackages.makeFullPerlPath perlDeps}"
    patchShebangs --build bin/{fix.pl,get_version.sh} tests/*/*
  '';

  postInstall = ''
    for f in "$out"/bin/{gen*,html2lcov,jacoco2lcov,lcov,llvm2lcov,perl2lcov}; do
      wrapProgram "$f" --set PERL5LIB ${perlPackages.makeFullPerlPath perlDeps}
    done
  '';

  doInstallCheck = true;

  nativeInstallCheckInputs = [ versionCheckHook ];

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
    changelog = "https://github.com/linux-test-project/lcov/releases/tag/v${finalAttrs.version}";
    license = lib.licenses.gpl2Plus;

    maintainers = with lib.maintainers; [ kamadorueda ];
    platforms = lib.platforms.all;
    mainProgram = "lcov";
  };
})
