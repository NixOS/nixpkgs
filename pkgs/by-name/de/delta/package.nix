{
  lib,
  rustPlatform,
  fetchFromGitHub,
  installShellFiles,
  pkg-config,
  oniguruma,
  stdenv,
  git,
  zlib,
}:

rustPlatform.buildRustPackage rec {
  pname = "delta";
  version = "0.18.2";

  src = fetchFromGitHub {
    owner = "dandavison";
    repo = "delta";
    rev = "refs/tags/${version}";
    hash = "sha256-fJSKGa935kwLG8WYmT9Ncg2ozpSNMzUJx0WLo1gtVAA=";
  };

  cargoHash = "sha256-DIWzRVTADfAZdFckhh2lIfOD13h7GP3KIOQHf/oBHgc=";

  nativeBuildInputs = [
    installShellFiles
    pkg-config
  ];

  buildInputs =
    [
      oniguruma
    ]
    ++ lib.optionals stdenv.hostPlatform.isDarwin [
      zlib
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

  checkFlags = lib.optionals stdenv.hostPlatform.isDarwin [
    # This test tries to read /etc/passwd, which fails with the sandbox
    # enabled on Darwin
    "--skip=test_diff_real_files"
  ];

  meta = with lib; {
    homepage = "https://github.com/dandavison/delta";
    description = "Syntax-highlighting pager for git";
    changelog = "https://github.com/dandavison/delta/releases/tag/${version}";
    license = licenses.mit;
    maintainers = with maintainers; [
      zowoq
      SuperSandro2000
      figsoda
    ];
    mainProgram = "delta";
  };
}
