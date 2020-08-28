{ rustPlatform, fetchFromGitHub, lib, fzf, makeWrapper }:

rustPlatform.buildRustPackage rec {
  pname = "navi";
  version = "2.9.0";

  src = fetchFromGitHub {
    owner = "denisidoro";
    repo = "navi";
    rev = "v${version}";
    sha256 = "16rwhpyk0zqks9z9bv2a1a8vww2m6867kg33bjbr29hawjg68jql";
  };

  cargoSha256 = "19w9gm389lj1zwhyjifhc2fzkvrvqvyc80lwxz070cnj11ir2l9m";

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
