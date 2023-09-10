{ lib
, rustPlatform
, fetchFromGitHub
, jq
, moreutils
, pkg-config
, openssl
, stdenv
, darwin
}:

rustPlatform.buildRustPackage rec {
  pname = "slippy";
  version = "0.1.0";

  src = fetchFromGitHub {
    owner = "axodotdev";
    repo = "slippy";
    rev = "v${version}";
    hash = "sha256-oxXmfvdnYmmKXvKHpJC23cvHaVdh5cpfQ1q5GPLskfY=";
  };

  cargoHash = "sha256-4MMTWhyi2/n9ESX2KJFERsXQHyGZunvArbYQmKiV7Eg=";

  # the dependency css-minify contains both README.md and Readme.md,
  # which causes a hash mismatch on systems with a case-insensitive filesystem
  # this removes the readme files and updates cargo's checksum file accordingly
  depsExtraArgs = {
    nativeBuildInputs = [
      jq
      moreutils
    ];

    postBuild = ''
      pushd $name/css-minify

      rm -f README.md Readme.md
      jq 'del(.files."README.md") | del(.files."Readme.md")' \
        .cargo-checksum.json -c \
        | sponge .cargo-checksum.json

      popd
    '';
  };

  nativeBuildInputs = [
    pkg-config
  ];

  buildInputs = [
    openssl
  ] ++ lib.optionals stdenv.isDarwin [
    darwin.apple_sdk.frameworks.Security
  ];

  meta = with lib; {
    description = "Markdown slideshows in Rust";
    homepage = "https://github.com/axodotdev/slippy";
    changelog = "https://github.com/axodotdev/slippy/releases/tag/${src.rev}";
    license = with licenses; [ asl20 mit ];
    maintainers = with maintainers; [ figsoda ];
  };
}
