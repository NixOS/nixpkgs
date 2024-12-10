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
  darwin,
  testers,
  leetcode-cli,
}:

rustPlatform.buildRustPackage rec {
  pname = "leetcode-cli";
  version = "0.4.3";

  src = fetchCrate {
    inherit pname version;
    sha256 = "sha256-y5zh93WPWSMDXqYangqrxav+sC0b0zpFIp6ZIew6KMo=";
  };

  cargoHash = "sha256-VktDiLsU+GOsa6ba9JJZGEPTavSKp+aSZm2dfhPEqMs=";

  nativeBuildInputs = [
    pkg-config
    installShellFiles
  ];

  buildInputs = [
    openssl
    dbus
    sqlite
  ] ++ lib.optionals stdenv.isDarwin [ darwin.apple_sdk.frameworks.Security ];

  postInstall = ''
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
