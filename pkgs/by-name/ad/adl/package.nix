{
  lib,
  stdenvNoCC,
  fetchFromGitHub,
  makeWrapper,
  versionCheckHook,
  animdl,
  bashNonInteractive,
  coreutils,
  frece,
  fzf,
  getopt,
  gnused,
  mpv,
  perl,
  trackma,
  ueberzugpp,
}:
stdenvNoCC.mkDerivation (finalAttrs: {
  pname = "adl";
  version = "3.2.8";

  src = fetchFromGitHub {
    owner = "RaitaroH";
    repo = "adl";
    rev = "a40f31454de856d9e9235d6216eaf8f4296111c4";
    hash = "sha256-Kg/iGyEdWJyoPn5lVqRCJX2eqdP1xwZqNU2RvTrhZko=";
  };

  nativeBuildInputs = [ makeWrapper ];

  # https://github.com/RaitaroH/adl#requirements
  buildInputs = [
    bashNonInteractive
  ];

  dontBuild = true;

  installPhase = ''
    runHook postInstall

    mkdir -p $out/bin
    cp $src/adl $out/bin
    wrapProgram $out/bin/adl \
      --prefix PATH : ${
        lib.makeBinPath [
          coreutils
          animdl
          frece
          fzf
          getopt
          gnused
          mpv
          perl
          trackma
          ueberzugpp
        ]
      }

    runHook preInstall
  '';

  doInstallCheck = true;
  nativeInstallCheckInputs = [ versionCheckHook ];

  meta = {
    homepage = "https://github.com/RaitaroH/adl";
    description = "Popcorn anime scraper/downloader + trackma wrapper";
    license = lib.licenses.gpl3Only;
    platforms = lib.platforms.linux;
    maintainers = with lib.maintainers; [ weathercold ];
    mainProgram = "adl";
  };
})
