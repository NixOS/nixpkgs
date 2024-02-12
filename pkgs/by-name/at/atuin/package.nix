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
  version = "18.0.0";

  src = fetchFromGitHub {
    owner = "atuinsh";
    repo = "atuin";
    rev = "v${version}";
    hash = "sha256-2nBaGoaTd1TGm8aZnrNA66HkW7+OrD6gOmj+uSFz020=";
  };

  patches = [
    # https://github.com/atuinsh/atuin/pull/1694
    (fetchpatch {
      name = "0001-atuin_src_command_client_search_interactive.rs.patch";
      url = "https://github.com/atuinsh/atuin/commit/6bc38f4cf3c8d2b6fbd135998a4e64e6abfb2566.patch";
      hash = "sha256-pUiuECiAmq7nmKO/cOHZ1V5Iy3zDzZyBNNCH7Czo/NA=";
    })
  ];

  # TODO: unify this to one hash because updater do not support this
  cargoHash =
    if stdenv.isLinux
    then "sha256-Y+49R/foid+V83tY3bqf644OkMPukJxg2/ZVfJxDaFg="
    else "sha256-gT2JRzBAF4IsXVv1Hvo6kr9qrNE/3bojtULCx6YawhA=";

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
    # further failing tests
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
