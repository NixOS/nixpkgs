{ lib
, stdenv
, fetchFromGitHub
, fetchpatch
, installShellFiles
, rustPlatform
, libiconv
, darwin
, nixosTests
}:

rustPlatform.buildRustPackage rec {
  pname = "atuin";
  version = "18.0.1";

  src = fetchFromGitHub {
    owner = "atuinsh";
    repo = "atuin";
    rev = "v${version}";
    hash = "sha256-fuVSn1vhKn2+Tw5f6zBYHFW3QSL4eisZ6d5pxsj5hh4=";
  };

  patches = [
    # atuin with bash-preexec wasn't recording history properly after searching,
    # backport recent fix until next release
    (fetchpatch {
      url = "https://github.com/atuinsh/atuin/commit/cb11af25afddbad552d337a9c82e74ac4302feca.patch";
      sha256 = "sha256-cG99aLKs5msatT7vXiX9Rn5xur2WUjQ/U33nOxuon7I=";
    })
  ];

  # TODO: unify this to one hash because updater do not support this
  cargoHash =
    if stdenv.isLinux
    then "sha256-lHWgsVnjSeBmd7O4Fn0pUtTn4XbkBOAouaRHRozil50="
    else "sha256-LxfpllzvgUu7ZuD97n3W+el3bdOt5QGXzJbDQ0w8seo=";

  # atuin's default features include 'check-updates', which do not make sense
  # for distribution builds. List all other default features.
  buildNoDefaultFeatures = true;
  buildFeatures = [
    "client" "sync" "server" "clipboard"
  ];

  nativeBuildInputs = [ installShellFiles ];

  buildInputs = lib.optionals stdenv.isDarwin [
    libiconv
    darwin.apple_sdk.frameworks.AppKit
    darwin.apple_sdk.frameworks.Security
    darwin.apple_sdk.frameworks.SystemConfiguration
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
