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
  version = "1.4.10";

  src = fetchFromGitHub {
    owner = "ipinfo";
    repo = "mmdbctl";
    tag = "mmdbctl-${version}";
    hash = "sha256-s1HKPZmuEENBf5a40i0oTtzvPV3UjMhS/1ijc9WtzXo=";
  };

  vendorHash = "sha256-f/FEMTOipss17uVhdvV3QKAmlHsmxnGWrz9csIs7ySk=";

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
