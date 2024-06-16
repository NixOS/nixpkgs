{
  lib,
  buildNpmPackage,
  fetchFromGitHub,
  callPackage,
  testers,
  runCommand,
  writeText,
  nix-update-script,
  lessc,
}:

buildNpmPackage rec {
  pname = "lessc";
  version = "4.2.0";

  src = fetchFromGitHub {
    owner = "less";
    repo = "less.js";
    rev = "v${version}";
    hash = "sha256-pOTKw+orCl2Y8lhw5ZyAqjFJDoka7uG7V5ae6RS1yqw=";
  };
  sourceRoot = "${src.name}/packages/less";

  npmDepsHash = "sha256-oPE2lo/lMiU8cnOciPW/gwzOtiehl9MGNncCrq1Hk+g=";

  postPatch = ''
    sed -i ./package.json \
      -e '/@less\/test-data/d' \
      -e '/@less\/test-import-module/d'
  '';

  env.PUPPETEER_SKIP_DOWNLOAD = 1;

  passthru = {
    updateScript = nix-update-script { };
    plugins = callPackage ./plugins { };
    wrapper = callPackage ./wrapper { };
    withPlugins = fn: lessc.wrapper.override { plugins = fn lessc.plugins; };
    tests = {
      version = testers.testVersion { package = lessc; };

      simple = testers.testEqualContents {
        assertion = "lessc compiles a basic less file";
        expected = writeText "expected" ''
          body h1 {
            color: red;
          }
        '';
        actual =
          runCommand "actual"
            {
              nativeBuildInputs = [ lessc ];
              base = writeText "base" ''
                @color: red;
                body {
                  h1 {
                    color: @color;
                  }
                }
              '';
            }
            ''
              lessc $base > $out
            '';
      };
    };
  };

  meta = {
    homepage = "https://github.com/less/less.js";
    description = "Dynamic stylesheet language";
    mainProgram = "lessc";
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [ lelgenio ];
  };
}
