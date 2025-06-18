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

stdenv.mkDerivation rec {

  pname = "rmount";
  version = "1.1.0";

  src = fetchFromGitHub {
    rev = "v${version}";
    owner = "Luis-Hebendanz";
    repo = "rmount";
    sha256 = "0j1ayncw1nnmgna7vyx44vwinh4ah1b0l5y8agc7i4s8clbvy3h0";
  };

  nativeBuildInputs = [ makeWrapper ];

  installPhase = ''
    install -D ${src}/rmount.man  $out/share/man/man1/rmount.1
    install -D ${src}/rmount.bash $out/bin/rmount
    install -D ${src}/config.json $out/share/config.json

    wrapProgram $out/bin/rmount --prefix PATH : ${
      lib.makeBinPath [
        nmap
        jq
        cifs-utils
        sshfs
      ]
    }
  '';

  meta = with lib; {
    homepage = "https://github.com/Luis-Hebendanz/rmount";
    description = "Remote mount utility which parses a json file";
    license = licenses.mit;
    maintainers = [ maintainers.qubasa ];
    platforms = platforms.linux;
    mainProgram = "rmount";
  };
}
