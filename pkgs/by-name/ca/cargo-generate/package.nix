{
  lib,
  rustPlatform,
  fetchFromGitHub,
  fetchpatch,
  pkg-config,
  libgit2,
  openssl,
  stdenv,
  darwin,
  gitMinimal,
}:

rustPlatform.buildRustPackage rec {
  pname = "cargo-generate";
  version = "0.22.1";

  src = fetchFromGitHub {
    owner = "cargo-generate";
    repo = "cargo-generate";
    rev = "v${version}";
    sha256 = "sha256-iOZCSd6jF1OF7ScjpsMlvMjsFHyg6QJJ6qk0OxrARho=";
  };

  useFetchCargoVendor = true;

  cargoPatches = [
    (fetchpatch {
      name = "git2-version.patch";
      url = "https://github.com/cargo-generate/cargo-generate/commit/be2237177ee7ae996e2991189b07a5d211cd0d01.patch";
      hash = "sha256-F/o1EeDBfRhIB8atpOHoc6ZnUFCyD1QkCERv4m/YeWE=";
    })
  ];

  cargoHash = "sha256-5cfROJQWIhQNMbDhaCs2bfv4I3KDWcXBsmbbbDQ331s=";

  nativeBuildInputs = [ pkg-config ];

  buildInputs =
    [
      libgit2
      openssl
    ]
    ++ lib.optionals stdenv.hostPlatform.isDarwin [
      darwin.apple_sdk.frameworks.Security
    ];

  nativeCheckInputs = [ gitMinimal ];

  # disable vendored libgit2 and openssl
  buildNoDefaultFeatures = true;

  preCheck = ''
    export HOME=$(mktemp -d) USER=nixbld
    git config --global user.name Nixbld
    git config --global user.email nixbld@localhost.localnet
  '';

  # Exclude some tests that don't work in sandbox:
  # - favorites_default_to_git_if_not_defined: requires network access to github.com
  # - should_canonicalize: the test assumes that it will be called from the /Users/<project_dir>/ folder on darwin variant.
  checkFlags =
    [
      "--skip=favorites::favorites_default_to_git_if_not_defined"
      "--skip=git_instead_of::should_read_the_instead_of_config_and_rewrite_an_git_at_url_to_https"
      "--skip=git_instead_of::should_read_the_instead_of_config_and_rewrite_an_ssh_url_to_https"
      "--skip=git_over_ssh::it_should_retrieve_the_private_key_from_ssh_agent"
      "--skip=git_over_ssh::it_should_support_a_public_repo"
      "--skip=git_over_ssh::it_should_use_a_ssh_key_provided_by_identity_argument"
    ]
    ++ lib.optionals stdenv.hostPlatform.isDarwin [
      "--skip=git::utils::should_canonicalize"
    ];

  env = {
    LIBGIT2_NO_VENDOR = 1;
  };

  meta = with lib; {
    description = "Tool to generate a new Rust project by leveraging a pre-existing git repository as a template";
    mainProgram = "cargo-generate";
    homepage = "https://github.com/cargo-generate/cargo-generate";
    changelog = "https://github.com/cargo-generate/cargo-generate/blob/v${version}/CHANGELOG.md";
    license = with licenses; [
      asl20 # or
      mit
    ];
    maintainers = with maintainers; [
      figsoda
      turbomack
      matthiasbeyer
    ];
  };
}
