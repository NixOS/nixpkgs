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
  version = "0.4.0";

  src = fetchCrate {
    inherit pname version;
    hash = "sha256-kBjiRPEWHKhX6vTB48TjKYhlpaiieNzE1l0PjaLTL4k=";
  };

  cargoHash = "sha256-vHLc738wFunyUDu6/B5foTE2/wExd2Yxcl638iqOWdw=";

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
      figsoda
      macalinao
      matthiasbeyer
    ];
    mainProgram = "cargo-workspaces";
  };
}
