{ lib
, stdenv
, rustPlatform
, fetchFromGitHub
, fetchpatch
, libiconv
, openssl
, pkg-config
, xclip
, AppKit
, Security
}:

rustPlatform.buildRustPackage rec {
  pname = "gitui";
  version = "0.22.1";

  src = fetchFromGitHub {
    owner = "extrawurst";
    repo = pname;
    rev = "v${version}";
    sha256 = "sha256-K6xWTPu2a5NKYAYBt/sCWQOmuw9TCoKPA4ZxkoLWmeY=";
  };

  cargoSha256 = "sha256-MZrx72poA6uOIulWIQkfOr9gy5qr5f61UtLITfES/rk=";

  patches = [
    # Fix errors in test `test_visualize_newline` on Rust 1.70
    # <https://github.com/extrawurst/gitui/pull/1646>
    (fetchpatch {
      url = "https://github.com/extrawurst/gitui/commit/c1e3e978a225d57bf365f61e0d35394ad1e85950.patch";
      hash = "sha256-N1dkEbjsUpBnAbXhk0qyywbjZoMkTVGNM6EDAKdwNi0=";
    })
  ];

  nativeBuildInputs = [ pkg-config ];

  buildInputs = [ openssl ]
    ++ lib.optional stdenv.isLinux xclip
    ++ lib.optionals stdenv.isDarwin [ libiconv Security AppKit ];

  # Needed to get openssl-sys to use pkg-config.
  OPENSSL_NO_VENDOR = 1;

  # The cargo config overrides linkers for some targets, breaking the build
  # on e.g. `aarch64-linux`. These overrides are not required in the Nix
  # environment: delete them.
  postPatch = "rm .cargo/config";

  meta = with lib; {
    description = "Blazing fast terminal-ui for Git written in Rust";
    homepage = "https://github.com/extrawurst/gitui";
    license = licenses.mit;
    maintainers = with maintainers; [ Br1ght0ne yanganto ];
  };
}
