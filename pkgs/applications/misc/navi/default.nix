{ rustPlatform, fetchFromGitHub, lib, fzf, makeWrapper }:

rustPlatform.buildRustPackage rec {
  pname = "navi";
  version = "2.7.1";

  src = fetchFromGitHub {
    owner = "denisidoro";
    repo = "navi";
    rev = "v${version}";
    sha256 = "12p9l41k7isaapr0xbsm7brkjrv7i8826y029i12psz92nsynk29";
  };

  cargoSha256 = "11dc3gc7fyikbbgacmljhysr2sl7lmq6w3bsfcf2cqny39r25yp0";

  nativeBuildInputs = [ makeWrapper ];

  postInstall = ''
    wrapProgram $out/bin/navi --prefix PATH : ${lib.makeBinPath [ fzf ]}
  '';

  meta = with lib; {
    description = "An interactive cheatsheet tool for the command-line and application launchers";
    homepage = "https://github.com/denisidoro/navi";
    license = licenses.asl20;
    platforms = platforms.unix;
    maintainers = with maintainers; [ cust0dian ];
  };
}
