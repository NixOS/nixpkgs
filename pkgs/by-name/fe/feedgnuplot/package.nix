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
  shortenPerlShebang,
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
  ]
  ++ lib.optional stdenv.hostPlatform.isDarwin shortenPerlShebang;

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

  postInstall =
    lib.optionalString stdenv.hostPlatform.isDarwin ''
      shortenPerlShebang $out/bin/feedgnuplot
    ''
    + ''
      wrapProgram $out/bin/feedgnuplot \
          --prefix "PATH" ":" "$PATH" \
          --prefix "PERL5LIB" ":" "$PERL5LIB"

      installShellCompletion --bash --name feedgnuplot.bash completions/bash/feedgnuplot
      installShellCompletion --zsh completions/zsh/_feedgnuplot
    '';

  meta = with lib; {
    description = "General purpose pipe-oriented plotting tool";
    homepage = "https://github.com/dkogan/feedgnuplot/";
    license = with licenses; [
      artistic1
      gpl1Plus
    ];
    platforms = platforms.unix;
    maintainers = with maintainers; [ mnacamura ];
    mainProgram = "feedgnuplot";
  };
}
