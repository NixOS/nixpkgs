{
  lib,
  stdenv,
  fetchFromGitHub,
  substitute,
  yarn-berry_4,
  nodejs,
  makeWrapper,
  versionCheckHook,
  nix-update-script,
}:

let
  yarn-berry = yarn-berry_4;
in
stdenv.mkDerivation (finalAttrs: {
  pname = "ovsx";
  version = "1.2.0";

  strictDeps = true;
  __structuredAttrs = true;

  src = fetchFromGitHub {
    owner = "eclipse-openvsx";
    repo = "openvsx";
    tag = "v${finalAttrs.version}";
    hash = "sha256-T/2tBWJcHJy4JiZk/tLrTtHLBsk8V628Mnb9ntw3pbo=";
    rootDir = "cli";
    postFetch = ''
      cd $out
      patch -p1 < ${
        (substitute {
          src = ./yarn-fix.patch;
          substitutions = [
            "--replace-fail"
            "YARN_LOCKFILE_VERSION_PLACEHOLDER"
            yarn-berry.lockfileVersion
          ];
        })
      }
    '';
  };

  missingHashes = ./missing-hashes.json;
  offlineCache = yarn-berry.fetchYarnBerryDeps {
    inherit (finalAttrs) src missingHashes;
    hash = "sha256-LlRP19pmh2rqS5o/xBntat5oPuGJIkrXRsquOE8qa0s=";
  };

  buildInputs = [ nodejs ];

  nativeBuildInputs = [
    makeWrapper
    nodejs
    yarn-berry.yarnBerryConfigHook
    yarn-berry
  ];

  buildPhase = ''
    runHook preBuild

    yarn run prepare

    runHook postBuild
  '';

  installPhase = ''
    mkdir -p $out/lib/ovsx
    cp -r bin $out/lib/ovsx
    cp -r lib $out/lib/ovsx
    cp -r node_modules $out/lib/ovsx

    substituteInPlace $out/lib/ovsx/bin/ovsx --replace-fail '../lib/main.js' "$out/lib/ovsx/lib/main.js"

    makeWrapper $out/lib/ovsx/bin/ovsx $out/bin/ovsx
  '';

  doInstallCheck = true;
  nativeInstallCheckInputs = [ versionCheckHook ];

  passthru = {
    updateScript = nix-update-script {
      extraArgs = [
        "--version-regex"
        "^v(\\d+\\.\\d+\\.\\d+)$"
      ];
    };
  };

  meta = {
    homepage = "https://github.com/eclipse-openvsx/openvsx/tree/main/cli";
    description = "Command line interface for Eclipse Open VSX";
    maintainers = with lib.maintainers; [ chvp ];
    license = lib.licenses.epl20;
    mainProgram = "ovsx";
  };
})
