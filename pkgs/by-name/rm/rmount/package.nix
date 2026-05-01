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
    owner = "Luis-Hebendanz";
    repo = "rmount";
    sha256 = "0j1ayncw1nnmgna7vyx44vwinh4ah1b0l5y8agc7i4s8clbvy3h0";
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
    homepage = "https://github.com/Luis-Hebendanz/rmount";
    description = "Remote mount utility which parses a json file";
    license = lib.licenses.mit;
    maintainers = [ lib.maintainers.qubasa ];
    platforms = lib.platforms.linux;
    mainProgram = "rmount";
  };
})
