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
<<<<<<< HEAD
  version = "0.24.2";
=======
  version = "0.22.1";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)

  src = fetchFromGitHub {
    owner = "extrawurst";
    repo = pname;
    rev = "v${version}";
<<<<<<< HEAD
    hash = "sha256-sqYG27TImVpsoG0PH5AQrAyFTHOXOJnWEqG9RxLbkLo=";
  };

  cargoHash = "sha256-Dlvr+lwCj68CSa2G2lc4dNShCfj56h9FqA9UZUOq+IQ=";
=======
    sha256 = "sha256-K6xWTPu2a5NKYAYBt/sCWQOmuw9TCoKPA4ZxkoLWmeY=";
  };

  cargoSha256 = "sha256-MZrx72poA6uOIulWIQkfOr9gy5qr5f61UtLITfES/rk=";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)

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

<<<<<<< HEAD

  # Getting app_config_path fails with a permission denied
  checkFlags = [
    "--skip=keys::key_config::tests::test_symbolic_links"
  ];


  meta = with lib; {
    description = "Blazing fast terminal-ui for Git written in Rust";
    homepage = "https://github.com/extrawurst/gitui";
    changelog = "https://github.com/extrawurst/gitui/blob/${version}/CHANGELOG.md";
    mainProgram = "gitui";
    license = licenses.mit;
    maintainers = with maintainers; [ Br1ght0ne yanganto mfrw ];
=======
  meta = with lib; {
    description = "Blazing fast terminal-ui for Git written in Rust";
    homepage = "https://github.com/extrawurst/gitui";
    license = licenses.mit;
    maintainers = with maintainers; [ Br1ght0ne yanganto ];
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
  };
}
