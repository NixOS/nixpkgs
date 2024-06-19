{ lib
, rustPlatform
, fetchFromGitHub
, installShellFiles
, pkg-config
, oniguruma
, stdenv
, darwin
, git
}:

rustPlatform.buildRustPackage rec {
  pname = "delta";
  version = "0.17.0";

  src = fetchFromGitHub {
    owner = "dandavison";
    repo = pname;
    rev = version;
    hash = "sha256-r0ED9o2UP91fe6Bng5ioJra5S1bg+UEXMLeSQPkMswI=";
  };

  cargoHash = "sha256-3CxRNhcjfDK/xUuM3w+GwqE0+X6WT92/LGj/qRp0TwA=";

  nativeBuildInputs = [
    installShellFiles
    pkg-config
  ];

  buildInputs = [
    oniguruma
  ] ++ lib.optionals stdenv.isDarwin [
    darwin.apple_sdk_11_0.frameworks.Foundation
  ];

  nativeCheckInputs = [ git ];

  env = {
    RUSTONIG_SYSTEM_LIBONIG = true;
  };

  postInstall = ''
    installShellCompletion --cmd delta \
      etc/completion/completion.{bash,fish,zsh}
  '';

  # test_env_parsing_with_pager_set_to_bat sets environment variables,
  # which can be flaky with multiple threads:
  # https://github.com/dandavison/delta/issues/1660
  dontUseCargoParallelTests = true;

  checkFlags = lib.optionals stdenv.isDarwin [
    "--skip=test_diff_same_non_empty_file"
  ];

  meta = with lib; {
    homepage = "https://github.com/dandavison/delta";
    description = "A syntax-highlighting pager for git";
    changelog = "https://github.com/dandavison/delta/releases/tag/${version}";
    license = licenses.mit;
    maintainers = with maintainers; [ zowoq SuperSandro2000 figsoda ];
    mainProgram = "delta";
  };
}
