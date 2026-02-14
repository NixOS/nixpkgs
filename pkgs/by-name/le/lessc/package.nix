{
  lib,
  stdenv,
  fetchFromGitHub,
  fetchPnpmDeps,
  nodejs,
  pnpm_9,
  pnpmConfigHook,
  callPackage,
  testers,
  runCommand,
  writeText,
  nix-update-script,
  lessc,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "lessc";
  version = "4.5.1";

  src = fetchFromGitHub {
    owner = "less";
    repo = "less.js";
    tag = "v${finalAttrs.version}";
    hash = "sha256-cf86h5Ittione1/1qzbaMtkdfKatDsN6wmCJMrB9iF4=";
  };

  pnpmDeps = fetchPnpmDeps {
    inherit (finalAttrs)
      pname
      version
      src
      pnpmWorkspaces
      ;
    pnpm = pnpm_9;
    fetcherVersion = 3;
    hash = "sha256-VPLOXME1kRCKMU/OuASX54fp+wiKe5MOyrosE1jIiTU=";
  };

  nativeBuildInputs = [
    pnpmConfigHook
    pnpm_9
  ];

  buildInputs = [ nodejs ];

  pnpmWorkspaces = [ "less..." ];

  buildPhase = ''
    runHook preBuild

    pnpm --filter "less" run build

    runHook postBuild
  '';

  installPhase = ''
    runHook preInstall

    mkdir -p $out/{bin,lib/lessc}
    cp -r {packages,node_modules} $out/lib/lessc
    chmod +x $out/lib/lessc/packages/less/bin/lessc
    ln -s $out/lib/lessc/packages/less/bin/lessc $out/bin/lessc

    runHook postInstall
  '';

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
})
