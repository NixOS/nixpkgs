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
  version = "4.2.2";

  src = fetchFromGitHub {
    owner = "less";
    repo = "less.js";
    rev = "v${version}";
    hash = "sha256-vO/1laFb1yC+OESXTx9KuGdwSNC9Iv49F3V7kfXnyJU=";
  };
  sourceRoot = "${src.name}/packages/less";

  npmDepsHash = "sha256-3GlngmaxcUGXSv+ZwN2aovwEqcek6FJ1ZaL5KpjwNn4=";

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
