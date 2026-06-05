{
  lib,
  stdenv,
  callPackage,
  fetchFromGitHub,
  fetchYarnDeps,
  yarnConfigHook,
  yarnBuildHook,
  yarnInstallHook,
  nodejs,
  yarn,
  moreutils,
  jq,
  makeBinaryWrapper,
  fetchpatch2,
  replaceVars,
}:
stdenv.mkDerivation (finalAttrs: {
  pname = "log4brains";
  version = "1.1.0";

  src = fetchFromGitHub {
    owner = "thomvaill";
    repo = "log4brains";
    tag = "v${finalAttrs.version}";
    hash = "sha256-2EAETbICK3XSjAEoLV0KP2xeOYlw8qgctit+shMp5Qs=";
  };

  yarnOfflineCache = fetchYarnDeps {
    yarnLock = finalAttrs.src + "/yarn.lock";
    hash = "sha256-HHiWlOYwR+PhfpQlUfuTXUiQ+6w1HATGlmflQvqdNlg=";
  };

  # generated from https://codeberg.org/tropf/log4brains
  patches = [
    # This replaces a version check by accessing package.json, which
    # in the nix packaging is not at the expected path
    (replaceVars ./0001-replace-version-check-using-package.json.patch {
      NIX_LOG4BRAINS_VERSION = finalAttrs.version;
    })

    ./0002-move-nextjs-build-into-temporary-directory.patch
  ];

  postPatch = ''
    # Top-level is just a workspace (actual packages reside in packages/
    # subdir), but w/o `version` the yarn hooks refuse to run.
    jq '.version = "${finalAttrs.version}"' < package.json | sponge package.json
  '';

  # = Notes =
  #
  # Not copying the full node_modules yields:
  # Error: Cannot find module 'chalk'
  #
  # The log4brains version in src/ and the default install differ,
  # hence remove the copied version and let installPhase handle it.
  #
  # An alternative approach is to bundle log4brains binary using (tested only in devshell):
  # npx pkg --target 'node*-linux-x64' .
  preInstall = ''
    mkdir -p $out/lib
    cp -aLrt $out/lib node_modules

    # will get installed by the installPhase, so avoid conflicts
    rm -r $out/lib/node_modules/log4brains

    # the desired final package is inside of a subdir; switch there
    pushd packages/global-cli
  '';

  # w/o yarn it just generated cryptic errors ENOENT
  #
  # There are some builds at runtime (marked as "hack" in the src),
  # hence we need node_modules set
  postInstall = ''
    popd

    wrapProgram $out/bin/log4brains \
      --suffix PATH : ${
        lib.makeBinPath [
          nodejs
          yarn
        ]
      } \
      --set NODE_PATH $out/lib/node_modules
  '';

  nativeBuildInputs = [
    yarnConfigHook
    yarnBuildHook
    yarnInstallHook
    # Needed for executing package.json scripts
    nodejs

    makeBinaryWrapper

    moreutils # sponge
    jq
  ];

  passthru.tests.basic-scenario = callPackage ./test-basic-scenario.nix {
    log4brains = finalAttrs.finalPackage;
  };

  meta = {
    description = "Architecture Decision Records (ADR) management and publication tool";
    longDescription = ''
      Log4brains is a docs-as-code knowledge base for your development and infrastructure projects.
      It enables you to log Architecture Decision Records (ADR) right from your IDE and to publish them automatically as a static website.
    '';
    homepage = "https://github.com/thomvaill/log4brains";
    license = lib.licenses.asl20;
    mainProgram = "log4brains";
    maintainers = with lib.maintainers; [ tropf ];
    platforms = lib.platforms.all;
  };
})
