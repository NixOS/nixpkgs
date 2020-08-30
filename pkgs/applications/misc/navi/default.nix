{ fetchFromGitHub, fzf, lib, makeWrapper, rustPlatform, wget }:

rustPlatform.buildRustPackage rec {
  pname = "navi";
  version = "2.10.0";

  src = fetchFromGitHub {
    owner = "denisidoro";
    repo = "navi";
    rev = "v${version}";
    sha256 = "1fpfc3ikb6rhb8m0dp9ybh46mnqaw361rrsbv6yrivwfm3zc4w2w";
  };

  cargoSha256 = "0klizxrb92h7qfxs89m08ksdq698wx4kxsdhqhr5ld9dy3b6ks32";

  nativeBuildInputs = [ makeWrapper ];

  postInstall = ''
    wrapProgram $out/bin/navi --prefix PATH : ${lib.makeBinPath [ fzf wget ]}
  '';

  meta = with lib; {
    description = "An interactive cheatsheet tool for the command-line and application launchers";
    homepage = "https://github.com/denisidoro/navi";
    license = licenses.asl20;
    platforms = platforms.unix;
    maintainers = with maintainers; [ cust0dian ];
  };
}
