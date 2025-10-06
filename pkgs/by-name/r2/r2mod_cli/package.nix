{
  fetchFromGitHub,
  bashInteractive,
  jq,
  makeWrapper,
  p7zip,
  lib,
  stdenv,
}:

stdenv.mkDerivation rec {
  pname = "r2mod_cli";
  version = "1.3.3.1";

  src = fetchFromGitHub {
    owner = "Foldex";
    repo = "r2mod_cli";
    rev = "v${version}";
    sha256 = "sha256-Y9ZffztxfGYiUSphqwhe3rTbnJ/vmGGi1pLml+1tLP8=";
  };

  buildInputs = [ bashInteractive ];

  nativeBuildInputs = [ makeWrapper ];

  makeFlags = [
    "DESTDIR="
    "PREFIX=$(out)"
  ];

  postInstall = ''
    wrapProgram $out/bin/r2mod --prefix PATH : "${
      lib.makeBinPath [
        jq
        p7zip
      ]
    }";
  '';

  meta = {
    description = "Risk of Rain 2 Mod Manager in Bash";
    homepage = "https://github.com/foldex/r2mod_cli";
    license = lib.licenses.gpl3Only;
    maintainers = [ lib.maintainers.reedrw ];
    mainProgram = "r2mod";
    platforms = lib.platforms.unix;
  };
}
