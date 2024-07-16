{ lib
, rustPlatform
, fetchFromGitHub
, cmake
, pkg-config
, stdenv
, libiconv
, Security
, SystemConfiguration
, curl
, openssl
, buildPackages
, installShellFiles
}:

let
  canRunCmd = stdenv.hostPlatform.emulatorAvailable buildPackages;
  gix = "${stdenv.hostPlatform.emulator buildPackages} $out/bin/gix";
  ein = "${stdenv.hostPlatform.emulator buildPackages} $out/bin/ein";
in rustPlatform.buildRustPackage rec {
  pname = "gitoxide";
  version = "0.36.0";

  src = fetchFromGitHub {
    owner = "Byron";
    repo = "gitoxide";
    rev = "v${version}";
    hash = "sha256-HXuMcLY5BAC2dODlI6sgwCyGEBDW6ojlHRCBnIQ6P6A=";
  };

  cargoHash = "sha256-v+HVrYMPwbD0RDyxufv11KOnWGbTljpbx6ZlSJ46Olk=";

  nativeBuildInputs = [ cmake pkg-config installShellFiles ];

  buildInputs = [ curl ] ++ (if stdenv.isDarwin
    then [ libiconv Security SystemConfiguration ]
    else [ openssl ]);

  preFixup = lib.optionalString canRunCmd ''
    installShellCompletion --cmd gix \
      --bash <(${gix} completions --shell bash) \
      --fish <(${gix} completions --shell fish) \
      --zsh <(${gix} completions --shell zsh)

    installShellCompletion --cmd ein \
      --bash <(${ein} completions --shell bash) \
      --fish <(${ein} completions --shell fish) \
      --zsh <(${ein} completions --shell zsh)
  '';

  # Needed to get openssl-sys to use pkg-config.
  env.OPENSSL_NO_VENDOR = 1;

  meta = with lib; {
    description = "Command-line application for interacting with git repositories";
    homepage = "https://github.com/Byron/gitoxide";
    changelog = "https://github.com/Byron/gitoxide/blob/v${version}/CHANGELOG.md";
    license = with licenses; [ mit /* or */ asl20 ];
    maintainers = with maintainers; [ syberant ];
  };
}
