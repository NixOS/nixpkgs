{
  lib,
  buildGoModule,
  fetchFromGitHub,
}:

buildGoModule rec {
  __structuredAttrs = true;
  pname = "modctl";
  version = "0.2.2";

  src = fetchFromGitHub {
    owner = "modelpack";
    repo = "modctl";
    rev = "v${version}";
    hash = "sha256-A7s2jM+hR5WgeiWzPjjfS/AJy35x6kzewIucz713zLc=";
  };

  vendorHash = "sha256-S1ygAZO3bTFi/3pwmNYE7P/Vqg7AVHpH5YRJ3yzzvyo=";

  ldflags = [
    "-s"
    "-w"
    "-X github.com/modelpack/modctl/pkg/version.GitVersion=v${version}"
  ];

  doInstallCheck = true;
  installCheckPhase = ''
    runHook preInstallCheck
    $out/bin/modctl --help > /dev/null
    $out/bin/modctl version --log-dir="$TMPDIR" --storage-dir="$TMPDIR" 2>&1 | grep -q "v${version}"
    runHook postInstallCheck
  '';

  meta = {
    description = "CLI tool for managing OCI model artifacts based on Model Spec";
    homepage = "https://github.com/modelpack/modctl";
    changelog = "https://github.com/modelpack/modctl/releases/tag/v${version}";
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [ gbhu753 ];
    mainProgram = "modctl";
  };
}
