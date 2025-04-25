{
  fetchFromGitHub,
  lib,
  openssl,
  perl,
  pkg-config,
  rustPlatform,
}:
rustPlatform.buildRustPackage (finalAttrs: {
  pname = "omnicli";
  version = "2025.4.0";

  src = fetchFromGitHub {
    owner = "xaf";
    repo = "omni";
    tag = "v${finalAttrs.version}";
    hash = "sha256-NRazjD20mmpe8dOoJNu8e/H8IRRkf/MLGKIxbw26Vbk=";
  };

  useFetchCargoVendor = true;
  cargoHash = "sha256-dn5epW07HO6c4sSNhhg4oZjPPYWKkxG+a7i1CrQNcok=";

  nativeBuildInputs = [
    pkg-config
    perl
  ];

  buildInputs = [ openssl ];

  patchPhase = ''
    substituteInPlace Cargo.toml \
      --replace 'version = "0.0.0-git"' 'version = "${finalAttrs.version}"'
    substituteInPlace Cargo.lock \
      --replace 'version = "0.0.0-git"' 'version = "${finalAttrs.version}"'
  '';

  checkPhase = ''
    cargo test -- \
      --skip internal::cache::up_environments::tests::up_environment::test_new_and_init \
      --skip internal::config::up::cargo_install::tests::install \
      --skip internal::config::up::github_release::tests::up
  '';

  meta = {
    homepage = "https://omnicli.dev/";
    description = "Omnipotent dev tool";
    changelog = "https://github.com/xaf/omni/releaes/tag/${finalAttrs.src.tag}";
    license = lib.licenses.lgpl21;
    maintainers = [ lib.maintainers.chadac ];
    mainProgram = "omni";
  };
})
