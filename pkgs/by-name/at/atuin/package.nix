{
  lib,
  stdenv,
  fetchFromGitHub,
  installShellFiles,
  rustPlatform,
  libiconv,
  darwin,
  nixosTests,
}:

rustPlatform.buildRustPackage rec {
  pname = "atuin";
  version = "18.2.0";

  src = fetchFromGitHub {
    owner = "atuinsh";
    repo = "atuin";
    rev = "v${version}";
    hash = "sha256-TTQ2XLqng7TMLnRsLDb/50yyHYuMSPZJ4H+7CEFWQQ0=";
  };

  # TODO: unify this to one hash because updater do not support this
  cargoHash =
    if stdenv.isLinux then
      "sha256-KMH19Op7uyb3Z/cjT6bdmO+JEp1o2n6rWRNYmn1+0hE="
    else
      "sha256-mBOyo6bKipMfmsowQujeUpog12jXAiqx5CtkwCxquRU=";

  # atuin's default features include 'check-updates', which do not make sense
  # for distribution builds. List all other default features.
  buildNoDefaultFeatures = true;
  buildFeatures = [
    "client"
    "sync"
    "server"
    "clipboard"
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
    # Tries to touch files
    "--skip=build_aliases"
  ];

  meta = with lib; {
    description = "Replacement for a shell history which records additional commands context with optional encrypted synchronization between machines";
    homepage = "https://github.com/atuinsh/atuin";
    license = licenses.mit;
    maintainers = with maintainers; [
      SuperSandro2000
      sciencentistguy
      _0x4A6F
    ];
    mainProgram = "atuin";
  };
}
