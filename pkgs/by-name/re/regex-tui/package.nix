{
  lib,
  buildGoModule,
  fetchFromGitHub,
  nix-update-script,
}:

buildGoModule (finalAttrs: {
  pname = "regex-tui";
  version = "0.8.0";

  src = fetchFromGitHub {
    owner = "vitor-mariano";
    repo = "regex-tui";
    tag = "v${finalAttrs.version}";
    hash = "sha256-MDRLcfGruBzFn2tkHNhDe3Ma0Sdodp+aG25BWKzjVPw=";
  };

  vendorHash = "sha256-tUc2zVdLvxTm68OCXbVYD5+SCkgbNVb1FP17NWmgtH4=";

  ldflags = [
    "-s"
    "-w"
  ];

  passthru.updateScript = nix-update-script { };

  meta = {
    description = "Visualize regular expressions right in your terminal";
    homepage = "https://github.com/vitor-mariano/regex-tui";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ yiyu ];
    mainProgram = "regex-tui";
  };
})
