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
  version = "1.0.88";

  __structuredAttrs = true;

  src = fetchFromGitHub {
    owner = "larksuite";
    repo = "cli";
    tag = "v${finalAttrs.version}";
    hash = "sha256-MRaFOq+0+ieNPG23ncYot/kp5hyWER7bX95I+trLHbw=";
  };

  vendorHash = "sha256-WClES7ilNmQ0018Qf13tNHouE/SIwh99MaewZ7VGQ2E=";

  subPackages = [ "." ];

  metaData = fetchurl {
    pname = "meta_data.json";
    inherit (finalAttrs) version;
    url = "https://open.feishu.cn/api/tools/open/api_definition?protocol=meta&client_version=v${finalAttrs.version}";
    hash = "sha256-JEt2n3mcTNMuZf81c9VyoruABrgXVz5u6SxHg+lTWDI=";
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
