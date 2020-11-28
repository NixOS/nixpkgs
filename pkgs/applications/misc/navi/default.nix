{ fetchFromGitHub, fzf, lib, makeWrapper, rustPlatform, wget }:

rustPlatform.buildRustPackage rec {
  pname = "navi";
  version = "2.12.1";

  src = fetchFromGitHub {
    owner = "denisidoro";
    repo = "navi";
    rev = "v${version}";
    sha256 = "1vrj8ad004h6jgmcb56f3f19s4xk6gvcpwysj78bxzgpa1998r3r";
  };

  cargoSha256 = "0yifgcf2pfszzny523ax7pb9a5r3012nynbnhdqg0j1ia1pdymf3";

  nativeBuildInputs = [ makeWrapper ];

  postInstall = ''
    wrapProgram $out/bin/navi \
      --prefix PATH : "$out/bin" \
      --prefix PATH : ${lib.makeBinPath [ fzf wget ]}
  '';

  meta = with lib; {
    description = "An interactive cheatsheet tool for the command-line and application launchers";
    homepage = "https://github.com/denisidoro/navi";
    license = licenses.asl20;
    platforms = platforms.unix;
    maintainers = with maintainers; [ cust0dian ];
  };
}
