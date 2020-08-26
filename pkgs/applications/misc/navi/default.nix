{ rustPlatform, fetchFromGitHub, lib, fzf, makeWrapper }:

rustPlatform.buildRustPackage rec {
  pname = "navi";
  version = "2.8.0";

  src = fetchFromGitHub {
    owner = "denisidoro";
    repo = "navi";
    rev = "v${version}";
    sha256 = "0w63yx4c60r05nfswv61jw3l3zbl5n1s396a6f4ayn52fb6rxwg1";
  };

  cargoSha256 = "06xpk04nxkm7h4nn235x8a4gi0qhscj8kkl2f9gqphlfmm56kjfn";

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
