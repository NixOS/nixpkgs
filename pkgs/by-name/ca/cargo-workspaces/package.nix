{
  lib,
  rustPlatform,
  fetchCrate,
  pkg-config,
  libssh2,
  openssl,
  zlib,
}:

rustPlatform.buildRustPackage rec {
  pname = "cargo-workspaces";
<<<<<<< HEAD
  version = "0.4.2";

  src = fetchCrate {
    inherit pname version;
    hash = "sha256-/h7v5Wq7YsNMVzLHw3QQmcknbjARpI7HFPAUGX72wZ0=";
  };

  cargoHash = "sha256-eaTLKQdz8Kyee7Bhub/OBueteeQ8jY36g4DgqctrToY=";
=======
  version = "0.4.1";

  src = fetchCrate {
    inherit pname version;
    hash = "sha256-5heOf74OUsnrG+vt9AdMXV7uRxqKYs0KRE7qm0irmC0=";
  };

  cargoHash = "sha256-Is2ddCrg+dP0TSw3EUl057RA0L2VW4mPttg2eAtC0j4=";
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)

  nativeBuildInputs = [
    pkg-config
  ];

  buildInputs = [
    libssh2
    openssl
    zlib
  ];

  env = {
    LIBSSH2_SYS_USE_PKG_CONFIG = true;
  };

  meta = {
    description = "Tool for managing cargo workspaces and their crates, inspired by lerna";
    longDescription = ''
      A tool that optimizes the workflow around cargo workspaces with
      git and cargo by providing utilities to version, publish, execute
      commands and more.
    '';
    homepage = "https://github.com/pksunkara/cargo-workspaces";
    changelog = "https://github.com/pksunkara/cargo-workspaces/blob/v${version}/CHANGELOG.md";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [
      macalinao
      matthiasbeyer
    ];
    mainProgram = "cargo-workspaces";
  };
}
