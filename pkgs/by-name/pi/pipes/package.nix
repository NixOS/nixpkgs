{
  lib,
  stdenv,
  fetchFromGitHub,
  makeWrapper,
  coreutils,
  ncurses,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "pipes";
  version = "1.3.0";

  src = fetchFromGitHub {
    owner = "pipeseroni";
    repo = "pipes.sh";
    rev = "v${finalAttrs.version}";
    hash = "sha256-856OWlnNiGB20571TJg7Ayzcz4r6NqdW5DMDiim09mc=";
  };

  nativeBuildInputs = [ makeWrapper ];

  installPhase = ''
    mkdir $out -p
    make PREFIX=$out/ install

    wrapProgram $out/bin/pipes.sh \
      --set PATH "${
        lib.makeBinPath [
          coreutils
          ncurses
        ]
      }"
  '';

  meta = {
    description = "Animated pipes terminal screensaver";
    homepage = "https://github.com/pipeseroni/pipes.sh";
    license = lib.licenses.mit;
    maintainers = [ lib.maintainers.matthiasbeyer ];
    mainProgram = "pipes.sh";
    platforms = lib.platforms.unix;
  };
})
