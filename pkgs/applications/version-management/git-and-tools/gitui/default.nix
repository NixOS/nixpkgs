{ lib
, stdenv
, rustPlatform
, fetchFromGitHub
, libiconv
, openssl
, pkg-config
, xclip
, AppKit
, Security
}:

rustPlatform.buildRustPackage rec {
  pname = "gitui";
  version = "0.21.0";

  src = fetchFromGitHub {
    owner = "extrawurst";
    repo = pname;
    rev = "v${version}";
    sha256 = "sha256-B/RKPYq1U40NV3AM/cQi2eQaK5vxynP3JA0DReSBuCo=";
  };

  cargoSha256 = "sha256-r4kritS3v8GgFZfWeeyrsy6v3IlH3DByTU8Ir4FDngs=";

  nativeBuildInputs = [ pkg-config ];

  buildInputs = [ openssl ]
    ++ lib.optional stdenv.isLinux xclip
    ++ lib.optionals stdenv.isDarwin [ libiconv Security AppKit ];

  # Needed to get openssl-sys to use pkg-config.
  OPENSSL_NO_VENDOR = 1;

  meta = with lib; {
    description = "Blazing fast terminal-ui for Git written in Rust";
    homepage = "https://github.com/extrawurst/gitui";
    license = licenses.mit;
    maintainers = with maintainers; [ Br1ght0ne yanganto ];
  };
}
