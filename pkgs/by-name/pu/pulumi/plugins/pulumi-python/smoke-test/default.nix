{
  lib,
  stdenvNoCC,
  pulumiTestHook,
  pulumi,
  pulumi-python,
  python3Packages,
}:
stdenvNoCC.mkDerivation {
  name = "pulumi-python-smoke-test";
  src = builtins.filterSource (name: _: !(lib.hasSuffix ".nix" name)) ./.;

  doCheck = true;

  nativeCheckInputs = [
    pulumiTestHook
    pulumi
    pulumi-python
    python3Packages.pulumi
  ];

  __darwinAllowLocalNetworking = true;

  checkPhase = ''
    runHook preCheck
    pulumi update --skip-preview
    stackOutput=$(pulumi stack output out)
    [[ $stackOutput =~ ^[0-9a-f]{32}$ ]]
    runHook postCheck
  '';

  installPhase = ''
    runHook preInstall
    mkdir -p "$out"
    runHook postInstall
  '';
}
