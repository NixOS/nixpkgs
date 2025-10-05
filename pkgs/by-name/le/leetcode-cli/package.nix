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
  version = "0.4.7";

  src = fetchCrate {
    inherit pname version;
    hash = "sha256-zxaBSZS2mlGaKT+AN4oS8eJmoLdVe2/T/G41ERj3gDg=";
  };

  cargoHash = "sha256-JsWMQp93fGXitnZ9LLGD9dZddc6Z7jRuAyx6HreV+XM=";

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

  meta = with lib; {
    description = "Leetcode CLI utility";
    homepage = "https://github.com/clearloop/leetcode-cli";
    license = licenses.mit;
    maintainers = with maintainers; [ congee ];
    mainProgram = "leetcode";
  };
}
