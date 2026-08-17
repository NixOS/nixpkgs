{
  lib,
  stdenv,
  fetchFromGitHub,
  fetchPnpmDeps,
  nodejs,
  pnpm_11,
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
  version = "4.6.7";

  src = fetchFromGitHub {
    owner = "less";
    repo = "less.js";
    tag = "v${finalAttrs.version}";
    hash = "sha256-D/gPyPoxHeLjF7EU40Jw2Mb4ZRrnaLq8XnL+kL2yhic=";
  };

  pnpmDeps = fetchPnpmDeps {
    inherit (finalAttrs)
      pname
      version
      src
      pnpmWorkspaces
      ;
    pnpm = pnpm_11;
    fetcherVersion = 4;
    hash = "sha256-tlms2b0aodWkI+btdmCnwSDgsURekaBdiI8IZ/iMVnI=";
  };

  strictDeps = true;

  nativeBuildInputs = [
    pnpmConfigHook
    pnpm_11
    nodejs
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
    changelog = "https://github.com/less/less.js/blob/${finalAttrs.src.tag}/CHANGELOG.md";
    description = "Dynamic stylesheet language";
    mainProgram = "lessc";
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [ lelgenio ];
  };
})
