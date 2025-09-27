{
  lib,
  stdenv,
  buildGoModule,
  fetchFromGitHub,
  installShellFiles,

  enableWasmEval ? false,
}:

assert
  enableWasmEval && stdenv.hostPlatform.isDarwin
  -> builtins.throw "building with wasm on darwin is failing in nixpkgs";

buildGoModule rec {
  pname = "opa-envoy-plugin";
  version = "1.9.0-envoy";

  src = fetchFromGitHub {
    owner = "open-policy-agent";
    repo = "opa-envoy-plugin";
    tag = "v${version}";
    hash = "sha256-Arc0aVDcGZqCrrUrAB9yVXSXzdtOlXEFGZ8pJ578oKk=";
  };

  vendorHash = null;

  nativeBuildInputs = [ installShellFiles ];

  subPackages = [ "./cmd/opa-envoy-plugin" ];

  ldflags = [
    "-s"
    "-w"
    "-X github.com/open-policy-agent/opa/v1/version.Version=${version}"
  ];

  tags = lib.optional enableWasmEval (
    builtins.trace (
      "Warning: enableWasmEval breaks reproducability, "
      + "ensure you need wasm evaluation. "
      + "`opa build` does not need this feature."
    ) "opa_wasm"
  );

  checkPhase = ''
    go test -v $(go list ./.../ | grep -v 'vendor')
  '';

  doInstallCheck = true;
  installCheckPhase = ''
    runHook preInstallCheck

    $out/bin/opa-envoy-plugin --help
    $out/bin/opa-envoy-plugin version
    $out/bin/opa-envoy-plugin version | grep "Version: ${version}"

    ${lib.optionalString enableWasmEval ''
      # If wasm is enabled verify it works
      $out/bin/opa eval -t wasm 'trace("hello from wasm")'
    ''}

    runHook postInstallCheck
  '';

  meta = {
    mainProgram = "opa";
    homepage = "https://www.openpolicyagent.org/docs/latest/envoy-introduction/";
    changelog = "https://github.com/open-policy-agent/opa-envoy-plugin/blob/v${version}/CHANGELOG.md";
    description = "Plugin to enforce OPA policies with Envoy";
    longDescription = ''
      OPA-Envoy extends OPA with a gRPC server that implements the Envoy
      External Authorization API. You can use this version of OPA to enforce
      fine-grained, context-aware access control policies with Envoy without
      modifying your microservice.
    '';
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [
      charlieegan3
    ];
  };
}
