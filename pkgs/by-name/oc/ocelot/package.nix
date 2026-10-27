{
  lib,
  stdenv,
  fetchFromGitHub,
  rustPlatform,
  installShellFiles,
}:

rustPlatform.buildRustPackage (finalAttrs: {
  pname = "ocelot";
  version = "0.5.2";

  src = fetchFromGitHub {
    owner = "xrelkd";
    repo = "ocelot";
    tag = "v${finalAttrs.version}";
    hash = "sha256-Z0RKEHeDhHjZtqXWueASMgiqnFRNsPe2rdoC7LZ/Mh8=";
  };

  cargoHash = "sha256-rJoIElM7fYg+oEV5idUNGys88x6dFeO4Ux8TxJKNqPU=";

  nativeBuildInputs = [
    installShellFiles
  ];

  postInstall = lib.optionalString (stdenv.buildPlatform.canExecute stdenv.hostPlatform) ''
    installShellCompletion --cmd ocelot \
      --bash <($out/bin/ocelot completions bash) \
      --fish <($out/bin/ocelot completions fish) \
      --zsh  <($out/bin/ocelot completions zsh)
  '';

  __structuredAttrs = true;

  meta = {
    description = "Process supervisor and init system written in Rust Programming Language";
    homepage = "https://github.com/xrelkd/ocelot";
    license = lib.licenses.gpl3Only;
    platforms = lib.platforms.linux;
    maintainers = with lib.maintainers; [ xrelkd ];
    mainProgram = "ocelot";
  };
})
