{
  lib,
  stdenv,
  fetchFromGitHub,
  ncurses,
  taglib,
  zlib,
  installShellFiles,
}:
stdenv.mkDerivation rec {
  pname = "stag";
  version = "1.0";

  src = fetchFromGitHub {
    owner = "smabie";
    repo = "stag";
    tag = "v${version}";
    hash = "sha256-IWb6ZbPlFfEvZogPh8nMqXatrg206BTV2DYg7BMm7R4=";
  };

  nativeBuildInputs = [
    installShellFiles
  ];
  buildInputs = [
    ncurses
    taglib
    zlib
  ];

  installPhase = ''
    runHook preInstall
    install -D stag $out/bin/stag-id3
    installManPage stag.1
    runHook postInstall
  '';
  meta = {
    mainProgram = "stag-id3";
    description = "public domain utf8 curses based audio file tagger";
    homepage = "https://github.com/smabie/stag";
    license = lib.licenses.publicDomain;
    maintainers = [ lib.maintainers.kmein ];
    platforms = lib.platforms.unix;
  };
}
