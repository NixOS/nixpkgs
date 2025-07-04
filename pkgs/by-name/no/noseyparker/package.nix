{
  lib,
  stdenv,
  rustPlatform,
  fetchFromGitHub,
  boost,
  cmake,
  vectorscan,
  openssl,
  pkg-config,
  installShellFiles,
  versionCheckHook,
}:

rustPlatform.buildRustPackage rec {
  pname = "noseyparker";
  version = "0.24.0";

  src = fetchFromGitHub {
    owner = "praetorian-inc";
    repo = "noseyparker";
    rev = "v${version}";
    hash = "sha256-6GxkIxLEgbIgg4nSHvmRedm8PAPBwVxLQUnQzh3NonA=";
  };

  useFetchCargoVendor = true;
  cargoHash = "sha256-hVBHIm/12WU6g45QMxxuGk41B0kwThk7A84fOxArvno=";

  checkFlags = [
    # These tests expect access to network to clone and use GitHub API
    "--skip=github::github_repos_list_multiple_user_dedupe_jsonl_format"
    "--skip=github::github_repos_list_org_badtoken"
    "--skip=github::github_repos_list_user_badtoken"
    "--skip=github::github_repos_list_user_human_format"
    "--skip=github::github_repos_list_user_json_format"
    "--skip=github::github_repos_list_user_jsonl_format"
    "--skip=github::github_repos_list_user_repo_filter"
    "--skip=scan::appmaker::scan_workflow_from_git_url"

    # This caused a flaky result. See https://github.com/NixOS/nixpkgs/pull/422012#issuecomment-3031728181
    "--skip=scan::git_url::git_binary_missing"

    # Also skips all tests which depend on external git command to prevent unstable tests similar to git_binary_missing
    # See https://github.com/NixOS/nixpkgs/pull/422012#discussion_r2182551619
    "--skip=scan::git_url::https_nonexistent"
    "--skip=scan::basic::scan_git_emptyrepo"
  ];

  nativeBuildInputs = [
    cmake
    pkg-config
    installShellFiles
  ];
  buildInputs = [
    boost
    vectorscan
    openssl
  ];

  OPENSSL_NO_VENDOR = 1;

  postInstall = lib.optionalString (stdenv.buildPlatform.canExecute stdenv.hostPlatform) ''
    mkdir -p manpages
    "$out/bin/noseyparker-cli" generate manpages
    installManPage manpages/*

    installShellCompletion --cmd noseyparker-cli \
      --bash <("$out/bin/noseyparker-cli" generate shell-completions --shell bash) \
      --zsh <("$out/bin/noseyparker-cli" generate shell-completions --shell zsh) \
      --fish <("$out/bin/noseyparker-cli" generate shell-completions --shell fish)
  '';

  nativeInstallCheckInputs = [
    versionCheckHook
  ];
  doInstallCheck = true;
  versionCheckProgram = "${placeholder "out"}/bin/noseyparker-cli";
  versionCheckProgramArg = "--version";

  meta = {
    description = "Find secrets and sensitive information in textual data";
    mainProgram = "noseyparker";
    homepage = "https://github.com/praetorian-inc/noseyparker";
    changelog = "https://github.com/praetorian-inc/noseyparker/blob/v${version}/CHANGELOG.md";
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [ _0x4A6F ];
  };
}
