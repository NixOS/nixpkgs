{ lib
, stdenv
, fetchFromGitHub
, installShellFiles
, rustPlatform
, libiconv
, darwin
, nixosTests
}:

rustPlatform.buildRustPackage rec {
  pname = "atuin";
  version = "18.1.0";

  src = fetchFromGitHub {
    owner = "atuinsh";
    repo = "atuin";
    rev = "v${version}";
    hash = "sha256-ddj8vHFTRBzeueSvY9kS1ZIcAID8k3MXrQkUVt04rQg=";
  };

  # TODO: unify this to one hash because updater do not support this
  cargoHash =
    if stdenv.isLinux
    then "sha256-LKHBXm9ZThX96JjxJb8d7cRdhWL1t/3aG3Qq1TYBC74="
    else "sha256-RSkC062XB5zy3lmI0OQhJfJ6FqFWXhpMPNIIqbrrlso=";

  # atuin's default features include 'check-updates', which do not make sense
  # for distribution builds. List all other default features.
  buildNoDefaultFeatures = true;
  buildFeatures = [
    "client" "sync" "server" "clipboard"
  ];

  nativeBuildInputs = [ installShellFiles ];

  buildInputs = lib.optionals stdenv.isDarwin [
    libiconv
    darwin.apple_sdk_11_0.frameworks.AppKit
    darwin.apple_sdk_11_0.frameworks.Security
    darwin.apple_sdk_11_0.frameworks.SystemConfiguration
  ];

  postInstall = ''
    installShellCompletion --cmd atuin \
      --bash <($out/bin/atuin gen-completions -s bash) \
      --fish <($out/bin/atuin gen-completions -s fish) \
      --zsh <($out/bin/atuin gen-completions -s zsh)
  '';

  passthru.tests = {
    inherit (nixosTests) atuin;
  };

  checkFlags = [
    # tries to make a network access
    "--skip=registration"
    # No such file or directory (os error 2)
    "--skip=sync"
    # PermissionDenied (Operation not permitted)
    "--skip=change_password"
    "--skip=multi_user_test"
  ];

  meta = with lib; {
    description = "Replacement for a shell history which records additional commands context with optional encrypted synchronization between machines";
    homepage = "https://github.com/atuinsh/atuin";
    license = licenses.mit;
    maintainers = with maintainers; [ SuperSandro2000 sciencentistguy _0x4A6F ];
    mainProgram = "atuin";
  };
}
