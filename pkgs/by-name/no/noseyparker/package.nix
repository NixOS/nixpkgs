{ lib
, rustPlatform
, fetchFromGitHub
, boost
, cmake
, git
, hyperscan
, openssl
, pkg-config
}:

rustPlatform.buildRustPackage rec {
  pname = "noseyparker";
  version = "0.21.0";

  src = fetchFromGitHub {
    owner = "praetorian-inc";
    repo = "noseyparker";
    rev = "v${version}";
    hash = "sha256-mRGlJto2b/oPLsvktQuBUsIO0kao9i4GjbmgztdAwiQ=";
  };

  cargoHash = "sha256-NibALhXquX/izimso8BBSWDCwDIykvbr7yN610nnOS4=";

  nativeCheckInputs = [
    git
  ];

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
  ];

  nativeBuildInputs = [
    cmake
    pkg-config
  ];
  buildInputs = [
    boost
    hyperscan
    openssl
  ];

  OPENSSL_NO_VENDOR = 1;

  meta = with lib; {
    description = "Find secrets and sensitive information in textual data";
    mainProgram = "noseyparker";
    homepage = "https://github.com/praetorian-inc/noseyparker";
    changelog = "https://github.com/praetorian-inc/noseyparker/blob/v${version}/CHANGELOG.md";
    license = licenses.asl20;
    maintainers = with maintainers; [ _0x4A6F ];
    # limited by hyperscan
    platforms = [ "x86_64-linux" ];
  };
}
