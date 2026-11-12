{
  stdenvNoCC,
  lib,
  fetchFromGitHub,
  fetchYarnDeps,
  yarnConfigHook,
  yarnBuildHook,
  yarnInstallHook,
  nodejs,
  nix-update-script,
  testers,
  writeText,
  runCommand,
  blade-formatter,
}:

stdenvNoCC.mkDerivation (finalAttrs: {
  pname = "blade-formatter";
  version = "1.44.6";

  src = fetchFromGitHub {
    owner = "shufo";
    repo = "blade-formatter";
    rev = "v${finalAttrs.version}";
    hash = "sha256-BU908gFul2CRYEq2lZ3Au1bHlTUa5Mky6ttxoxg0A14=";
  };

  yarnOfflineCache = fetchYarnDeps {
    yarnLock = finalAttrs.src + "/yarn.lock";
    hash = "sha256-P6UMN6506a7FKsdhEq5DpMrY/Pk3OWMuFLL2rW9r+1o=";
  };

  nativeBuildInputs = [
    yarnConfigHook
    yarnBuildHook
    yarnInstallHook
    nodejs
  ];

  passthru = {
    updateScript = nix-update-script { };
    tests = {
      version = testers.testVersion {
        package = blade-formatter;
        command = "blade-formatter --version";
      };

      simple = testers.testEqualContents {
        assertion = "blade-formatter formats a basic blade file";
        expected = writeText "expected" ''
          @if (true)
              Hello world!
          @endif
        '';
        actual =
          runCommand "actual"
            {
              nativeBuildInputs = [ blade-formatter ];
              base = writeText "base" ''
                @if(   true )  Hello world!   @endif
              '';
            }
            ''
              blade-formatter $base > $out
            '';
      };
    };
  };

  meta = {
    description = "Laravel Blade template formatter";
    homepage = "https://github.com/shufo/blade-formatter";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ lelgenio ];
    mainProgram = "blade-formatter";
    inherit (nodejs.meta) platforms;
  };
})
