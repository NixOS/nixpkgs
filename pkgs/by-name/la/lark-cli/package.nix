{
  lib,
  buildGoModule,
  fetchFromGitHub,
  fetchurl,
  runCommand,
  jq,
  testers,
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

  postPatch =
    let
      metaDataRaw = fetchurl {
        name = "meta_dataraw.json";
        url = "https://web.archive.org/web/20260626061256/https://open.feishu.cn/api/tools/open/api_definition?protocol=meta&client_version=v${finalAttrs.version}";
        hash = "sha256-W6KOtDW6gkZIqGa0A5QL0rVjVkRjM+gwW4S3AddPN1M=";
      };

      metaData =
        runCommand "meta_data.json"
          {
            nativeBuildInputs = [ jq ];
          }
          ''
            jq '.data' ${metaDataRaw} > $out
          '';
    in
    ''
      cp ${metaData} internal/registry/meta_data.json
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

  passthru.updateScript = ./update.sh;

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
