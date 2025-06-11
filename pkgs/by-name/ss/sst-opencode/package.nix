{
  lib,
  fetchFromGitHub,
  buildGoModule,
}:
buildGoModule (finalAttrs: {
  pname = "sst-opencode";
  version = "0.0.52";

  src = fetchFromGitHub {
    owner = "sst";
    repo = "opencode";
    tag = "v${finalAttrs.version}";
    hash = "sha256-wniGu8EXOI2/sCI7gv2luQgODRdes7tt1CoJ6Gs09ig=";
  };

  vendorHash = "sha256-pnev0o2/jirTqG67amCeI49XUdMCCulpGq/jYqGqzRY=";

  checkFlags =
    let
      skippedTests = [
        # permission denied
        "TestBashTool_Run"
        "TestSourcegraphTool_Run"
        "TestLsTool_Run"
      ];
    in
    [ "-skip=^${lib.concatStringsSep "$|^" skippedTests}$" ];

  meta = {
    description = "AI coding agent, built for the terminal.";
    homepage = "https://github.com/sst/opencode";
    mainProgram = "opencode";
    license = lib.licenses.mit;
    maintainers = [ lib.maintainers.cowboycodr ];
  };
})
