{ fetchFromGitHub, fzf, lib, makeWrapper, rustPlatform, wget }:

rustPlatform.buildRustPackage rec {
  pname = "navi";
  version = "2.13.1";

  src = fetchFromGitHub {
    owner = "denisidoro";
    repo = "navi";
    rev = "v${version}";
    sha256 = "0nzjcahnx637m24xhzgrhvaic52b1bqx6lkklmy8xlbka7i2xid2";
  };

  cargoSha256 = "12xyh57b6lblplh87fw1cvfwzkx9bz9qbhii34n4yzfzp6sv530n";

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
