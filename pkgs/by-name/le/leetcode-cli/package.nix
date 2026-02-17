{
  lib,
  fetchCrate,
  rustPlatform,
  pkg-config,
  installShellFiles,
  openssl,
  dbus,
  sqlite,
  stdenv,
  testers,
  leetcode-cli,
}:

rustPlatform.buildRustPackage rec {
  pname = "leetcode-cli";
  version = "0.5.0";

  src = fetchCrate {
    inherit pname version;
    hash = "sha256-EafEz5MhY9f56N1LCPaW+ktYrV01r9vHCbublDnfAKg=";
  };

  cargoHash = "sha256-8bHpNckEsJ4VWlmEaDTeMW+Txi9SQh30lK5CKKperC8=";

  nativeBuildInputs = [
    pkg-config
    installShellFiles
  ];

  buildInputs = [
    openssl
    dbus
    sqlite
  ];

  postInstall = lib.optionalString (stdenv.buildPlatform.canExecute stdenv.hostPlatform) ''
    installShellCompletion --cmd leetcode \
      --bash <($out/bin/leetcode completions bash) \
      --fish <($out/bin/leetcode completions fish) \
      --zsh <($out/bin/leetcode completions zsh)
  '';

  passthru.tests = testers.testVersion {
    package = leetcode-cli;
    command = "leetcode -V";
    version = "leetcode ${version}";
  };

  meta = {
    description = "Leetcode CLI utility";
    homepage = "https://github.com/clearloop/leetcode-cli";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ congee ];
    mainProgram = "leetcode";
  };
}
