{ fetchFromGitHub, fzf, lib, makeWrapper, rustPlatform, wget }:

rustPlatform.buildRustPackage rec {
  pname = "navi";
  version = "2.12.0";

  src = fetchFromGitHub {
    owner = "denisidoro";
    repo = "navi";
    rev = "v${version}";
    sha256 = "0izmf4flwwn2h1wwpsnghb6rd494lj63hhsky1v9v6l1l641had4";
  };

  cargoSha256 = "19xv9kbmxbp84lj8ycifsdr7sw9vhwgla7cdmrvlhayiq5r04xd7";

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
