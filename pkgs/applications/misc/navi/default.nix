{ stdenv, fetchFromGitHub, fzf, lib, makeWrapper, rustPlatform, wget, libiconv }:

rustPlatform.buildRustPackage rec {
  pname = "navi";
  version = "2.16.0";

  src = fetchFromGitHub {
    owner = "denisidoro";
    repo = "navi";
    rev = "v${version}";
    sha256 = "sha256-ngSZFYGE+Varul/qwavMO3xcMIp8w2WETWXc573wYhQ=";
  };

  cargoSha256 = "sha256-qtxFTk0iCxPa4Z7H9+QWSii+iYrLUV2LfiAEbePdhOQ=";

  nativeBuildInputs = [ makeWrapper ];

  buildInputs = lib.optionals stdenv.isDarwin [ libiconv ];

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
