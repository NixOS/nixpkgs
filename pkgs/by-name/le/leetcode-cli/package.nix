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
  version = "0.4.8";

  src = fetchCrate {
    inherit pname version;
    hash = "sha256-5ap0XjbzcB+n42E7la7AVDlrUQtZGtnwrS7opFRUD7o=";
  };

  cargoHash = "sha256-EIU0dGf1ftCQPi8eHSfD9OKHEq4JDZYKRw79BWXK/CY=";

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
