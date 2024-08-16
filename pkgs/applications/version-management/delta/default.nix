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
  version = "0.17.0-unstable-2024-08-12";

  src = fetchFromGitHub {
    owner = "dandavison";
    repo = pname;
    rev = "a01141b72001f4c630d77cf5274267d7638851e4";
    hash = "sha256-My51pQw5a2Y2VTu39MmnjGfmCavg8pFqOmOntUildS0=";
  };

  cargoHash = "sha256-Rlc3Bc6Jh89KLLEWBWQB5GjoeIuHnwIVZN/MVFMjY24=";

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
    description = "Syntax-highlighting pager for git";
    changelog = "https://github.com/dandavison/delta/releases/tag/${version}";
    license = licenses.mit;
    maintainers = with maintainers; [ zowoq SuperSandro2000 figsoda ];
    mainProgram = "delta";
  };
}
