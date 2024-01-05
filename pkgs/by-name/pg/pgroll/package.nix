{ lib
, buildGoModule
, fetchFromGitHub
  # for completions
, stdenv
, installShellFiles
, buildPackages
}:

buildGoModule rec {
  pname = "pgroll";
  version = "0.4.4";

  src = fetchFromGitHub {
    owner = "xataio";
    repo = "pgroll";
    rev = "v${version}";
    hash = "sha256-v9XtOzKZVIn2aLRUKP/Lpm3UkweHIapUdZt384OX7lc=";
  };

  vendorHash = "sha256-eNSTDpSkxJcctYfJ3Mnwi8THdZx6ysfzxk/qVnXR0PA=";

  ldflags = [
    "-s"
    "-w"
    "-X=github.com/xataio/pgroll/cmd.Version=${version}"
  ];

  nativeBuildInputs = [ installShellFiles ];

  # tests use docker
  doCheck = false;

  postInstall =
    let
      execSelf = if stdenv.buildPlatform.canExecute stdenv.hostPlatform then placeholder "out" else buildPackages.pgroll;
      cmd = meta.mainProgram;
    in
    ''
      installShellCompletion --cmd ${cmd} \
        --bash <(${execSelf}/bin/${cmd} completion bash) \
        --fish <(${execSelf}/bin/${cmd} completion fish) \
        --zsh <(${execSelf}/bin/${cmd} completion zsh)
    '';

  meta = with lib; {
    description = "PostgreSQL zero-downtime migrations made easy";
    longDescription = ''
      pgroll is an open source command-line tool that offers safe and reversible
      schema migrations for PostgreSQL by serving multiple schema versions
      simultaneously. It takes care of the complex migration operations to
      ensure that client applications continue working while the database schema
      is being updated. This includes ensuring changes are applied without
      locking the database, and that both old and new schema versions work
      simultaneously (even when breaking changes are being made!). This removes
      risks related to schema migrations, and greatly simplifies client
      application rollout, also allowing for instant rollbacks.
    '';
    homepage = "https://github.com/xataio/pgroll";
    license = licenses.asl20;
    maintainers = with maintainers; [ jk prit342 ];
    mainProgram = "pgroll";
  };
}
