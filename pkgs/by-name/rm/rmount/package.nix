{
  lib,
  stdenv,
  nmap,
  jq,
  cifs-utils,
  sshfs,
  fetchFromGitHub,
  makeWrapper,
}:

stdenv.mkDerivation (finalAttrs: {

  pname = "rmount";
  version = "1.1.0";

  src = fetchFromGitHub {
    rev = "v${finalAttrs.version}";
    owner = "Qubasa";
    repo = "rmount";
    hash = "sha256-AA6/F2VIk3jYU8gXClaAikAb+Sak+32UfdXawJn1Kkg=";
  };

  nativeBuildInputs = [ makeWrapper ];

  installPhase = ''
    install -D ${finalAttrs.src}/rmount.man  $out/share/man/man1/rmount.1
    install -D ${finalAttrs.src}/rmount.bash $out/bin/rmount
    install -D ${finalAttrs.src}/config.json $out/share/config.json

    wrapProgram $out/bin/rmount --prefix PATH : ${
      lib.makeBinPath [
        nmap
        jq
        cifs-utils
        sshfs
      ]
    }
  '';

  meta = {
    homepage = "https://github.com/Qubasa/rmount";
    description = "Remote mount utility which parses a json file";
    license = lib.licenses.mit;
    maintainers = [ lib.maintainers.qubasa ];
    platforms = lib.platforms.linux;
    mainProgram = "rmount";
  };
})
