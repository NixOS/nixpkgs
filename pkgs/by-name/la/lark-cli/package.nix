{
  lib,
  buildGoModule,
  fetchFromGitHub,
  fetchurl,
  jq,
  testers,
  nix-update-script,
}:

buildGoModule (finalAttrs: {
  pname = "lark-cli";
  version = "1.0.58";

  __structuredAttrs = true;

  src = fetchFromGitHub {
    owner = "larksuite";
    repo = "cli";
    tag = "v${finalAttrs.version}";
    hash = "sha256-MqaxcmzX/79vM2EI8wD4ZAFsUfqWvPAovlpmuDP1IWU=";
  };

  vendorHash = "sha256-M0/Y62Y+M/P1B/YIDjX5bEyB/GKihCWQakTWVd7zvBg=";

  subPackages = [ "." ];

  metaData = fetchurl {
    name = "meta_data.json";
    url = "https://open.feishu.cn/api/tools/open/api_definition?protocol=meta&client_version=v${finalAttrs.version}";
    hash = "sha256-ihPrq/VzFIBnlrKxE2762NpQZzBRk7ylM3Mvg0iJfCE=";
    postFetch = ''
      ${lib.getExe jq} -S ".data" "$out" > normalized
      mv normalized "$out"
    '';
  };

  postPatch = ''
    cp ${finalAttrs.metaData} internal/registry/meta_data.json
  '';

  postInstall = ''
    mv $out/bin/cli $out/bin/lark-cli
  '';

  ldflags = [
    "-s"
    "-w"
    "-X github.com/larksuite/cli/internal/build.Version=v${finalAttrs.version}"
    "-X github.com/larksuite/cli/internal/build.Date=2026-06-01"
  ];

  passthru = {
    inherit (finalAttrs) metaData;
    updateScript = nix-update-script {
      extraArgs = [
        "--custom-dep"
        "metaData"
      ];
    };
  };

  passthru.tests.version = testers.testVersion {
    package = finalAttrs.finalPackage;
    command = "lark-cli --version";
    version = "v${finalAttrs.version}";
  };

  meta = {
    description = "The official CLI for Lark/Feishu open platform";
    homepage = "https://github.com/larksuite/cli";
    changelog = "https://github.com/larksuite/cli/releases/tag/v${finalAttrs.src.tag}";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ zehuajun ];
    mainProgram = "lark-cli";
  };
})
