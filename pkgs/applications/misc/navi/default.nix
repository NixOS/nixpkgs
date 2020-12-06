{ fetchFromGitHub, fzf, lib, makeWrapper, rustPlatform, wget }:

rustPlatform.buildRustPackage rec {
  pname = "navi";
  version = "2.13.0";

  src = fetchFromGitHub {
    owner = "denisidoro";
    repo = "navi";
    rev = "v${version}";
    sha256 = "04ks38s6d3nkdj0arhxw8f3sfw796l97fbqxsm7b9g5d2953a6cs";
  };

  cargoSha256 = "1zwar1l793809bsgqnwrgi50y76bd78qd4s8lw6d64f4z72dh80g";

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
