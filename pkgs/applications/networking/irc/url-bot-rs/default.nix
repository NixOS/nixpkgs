{ stdenv
, lib
, rustPlatform
, fetchFromGitHub
, pkg-config
, openssl
, sqlite
, libiconv
, Security
}:

rustPlatform.buildRustPackage rec {
  pname = "url-bot-rs";
  version = "0.3.1";

  src = fetchFromGitHub {
    owner = "nuxeh";
    repo = pname;
    rev = "v${version}";
    sha256 = "0y183z86rkpxxvvzrkkpdxxxpd7lr8nnmwi5nv7k8cfb8fa0xl8n";
  };

  cargoSha256 = "0081liwxwxd86amlpkwncdnbbykab42c2myqsxr44k6a9yliivsp";

  nativeBuildInputs = [ pkg-config ];

  buildInputs = [
    openssl
    sqlite
  ] ++ lib.optionals stdenv.isDarwin [
    libiconv
    Security
  ];

  preBuild = ''
    export HOME=$TMPDIR
  '';

  meta = with lib; {
    description = "Minimal IRC URL bot in Rust";
    homepage = "https://github.com/nuxeh/url-bot-rs";
    license = licenses.isc;
    maintainers = with maintainers; [ hexa ];
  };
}
