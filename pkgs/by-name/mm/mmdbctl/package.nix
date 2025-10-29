{
  lib,
  buildGoModule,
  fetchFromGitHub,
  installShellFiles,
  stdenv,
  runCommand,
  mmdbctl,
  dbip-country-lite,
}:

buildGoModule rec {
  pname = "mmdbctl";
  version = "1.4.8";

  src = fetchFromGitHub {
    owner = "ipinfo";
    repo = "mmdbctl";
    tag = "mmdbctl-${version}";
    hash = "sha256-9s/dyORfv3lNf9W6oE1PHhaTgJFdeFa46pf54c/cwH0=";
  };

  vendorHash = "sha256-4T3HEzRerC4KrGQnMNSW3OVzChUIf4yJ7qS9v8mWIX4=";

  ldflags = [
    "-s"
    "-w"
  ];

  nativeBuildInputs = [ installShellFiles ];

  postInstall = lib.optionalString (stdenv.buildPlatform.canExecute stdenv.hostPlatform) ''
    installShellCompletion --cmd mmdbctl \
      --bash <($out/bin/mmdbctl completion bash) \
      --fish <($out/bin/mmdbctl completion fish) \
      --zsh <($out/bin/mmdbctl completion zsh)
  '';

  passthru.tests = {
    simple = runCommand "${pname}-test" { } ''
      ${lib.getExe mmdbctl} verify ${dbip-country-lite.mmdb} | grep valid
      ${lib.getExe mmdbctl} metadata ${dbip-country-lite.mmdb} | grep DBIP-Country-Lite
      touch $out
    '';
  };

  meta = {
    description = "MMDB file management CLI supporting various operations on MMDB database files";
    homepage = "https://github.com/ipinfo/mmdbctl";
    changelog = "https://github.com/ipinfo/mmdbctl/blob/${src.rev}/CHANGELOG.md";
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [ moraxyc ];
    mainProgram = "mmdbctl";
  };
}
