{
  stdenvNoCC,
  lib,
  fetchFromGitHub,
  makeWrapper,
  installShellFiles,
  coreutils,
  findutils,
  gawk,
  iconv,
  wget,
}:
stdenvNoCC.mkDerivation rec {
  pname = "podget";
  version = "1.0.0";

  src = fetchFromGitHub {
    owner = "dvehrs";
    repo = "podget";
    tag = "V${version}";
    hash = "sha256-0I42UPWTdSzfRJodB1v3BNI5vwt8GRGpHR7eACoR9YQ=";
  };

  buildInputs = [
    coreutils
    findutils
    gawk
    iconv
    wget
  ];
  nativeBuildInputs = [
    makeWrapper
    installShellFiles
  ];
  installPhase = ''
    installManPage DOC/podget.7
    install -m 755 -D podget $out/bin/podget
    wrapProgram $out/bin/podget --prefix PATH : ${
      lib.makeBinPath [
        coreutils
        findutils
        gawk
        iconv
        wget
      ]
    }
  '';

  meta = {
    description = "Podcast aggregator optimized for running as a scheduled job (i.e. cron) on Linux";
    homepage = "https://github.com/dvehrs/podget";
    changelog = "https://github.com/dvehrs/podget/blob/dev/Changelog";
    license = lib.licenses.gpl3;
    platforms = lib.platforms.all;
    maintainers = with lib.maintainers; [ _9R ];
    mainProgram = "podget";
  };
}
