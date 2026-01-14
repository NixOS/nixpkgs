{
  lib,
  fetchFromGitHub,
  makeWrapper,
  makeFontsConf,
  freefont_ttf,
  gnuplot,
  perl,
  perlPackages,
  stdenv,
  installShellFiles,
}:

let

  fontsConf = makeFontsConf { fontDirectories = [ freefont_ttf ]; };

in

perlPackages.buildPerlPackage rec {
  pname = "feedgnuplot";
  version = "1.61";

  src = fetchFromGitHub {
    owner = "dkogan";
    repo = "feedgnuplot";
    rev = "v${version}";
    sha256 = "sha256-r5rszxr65lSozkUNaqfBn4I4XjLtvQ6T/BG366JXLRM=";
  };

  outputs = [ "out" ];

  nativeBuildInputs = [
    makeWrapper
    installShellFiles
  ];

  buildInputs = [
    gnuplot
    perl
  ]
  ++ (with perlPackages; [
    ListMoreUtils
    IPCRun
    StringShellQuote
  ]);

  # Fontconfig error: Cannot load default config file
  FONTCONFIG_FILE = fontsConf;

  postPatch = ''
    patchShebangs .
  '';

  # Tests require gnuplot 4.6.4 and are completely skipped with gnuplot 5.
  doCheck = false;

  postInstall = ''
    wrapProgram $out/bin/feedgnuplot \
        --prefix "PATH" ":" "$PATH" \
        --prefix "PERL5LIB" ":" "$PERL5LIB"

    installShellCompletion --bash --name feedgnuplot.bash completions/bash/feedgnuplot
    installShellCompletion --zsh completions/zsh/_feedgnuplot
  '';

  meta = {
    description = "General purpose pipe-oriented plotting tool";
    homepage = "https://github.com/dkogan/feedgnuplot/";
    license = with lib.licenses; [
      artistic1
      gpl1Plus
    ];
    platforms = lib.platforms.unix;
    maintainers = with lib.maintainers; [ mnacamura ];
    mainProgram = "feedgnuplot";
  };
}
