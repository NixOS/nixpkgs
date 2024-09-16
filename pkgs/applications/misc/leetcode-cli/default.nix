{ lib
, fetchCrate
, rustPlatform
, pkg-config
, installShellFiles
, openssl
, dbus
, sqlite
, stdenv
, darwin
, testers
, leetcode-cli
}:

rustPlatform.buildRustPackage rec {
  pname = "leetcode-cli";
  version = "0.4.5";

  src = fetchCrate {
    inherit pname version;
    hash = "sha256-Jc0akHj2DHbkF7sjslOwdeI1piW2gnhoalBz18lpQdQ=";
  };

  cargoHash = "sha256-t3u82bjO1Qv32TwpZNCaaEqOVajXIgM7VBNQ4UjMcl8=";

  nativeBuildInputs = [
    pkg-config
    installShellFiles
  ];

  buildInputs = [
    openssl
    dbus
    sqlite
  ] ++ lib.optionals stdenv.isDarwin [ darwin.apple_sdk.frameworks.Security ];

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
    description = "May the code be with you 👻";
    longDescription = "Use leetcode.com in command line";
    homepage = "https://github.com/clearloop/leetcode-cli";
    license = licenses.mit;
    maintainers = with maintainers; [ congee ];
    mainProgram = "leetcode";
  };
}
