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
  makeWrapper,
}:
let
  pname = "log4brains";
  version = "1.1.0";
  srcHash = "sha256-2EAETbICK3XSjAEoLV0KP2xeOYlw8qgctit+shMp5Qs=";
  yarnHash = "sha256-HHiWlOYwR+PhfpQlUfuTXUiQ+6w1HATGlmflQvqdNlg=";
in
stdenv.mkDerivation (finalAttrs: {
  inherit pname version;

  src = fetchFromGitHub {
    owner = "thomvaill";
    repo = pname;
    rev = "v${version}";
    hash = srcHash;
  };

  yarnOfflineCache = fetchYarnDeps {
    yarnLock = finalAttrs.src + "/yarn.lock";
    hash = yarnHash;
  };

  patches = [ ./builddir.patch ];

  postPatch = ''
    # Top-level is just a workspace (actual packages reside in packages/
    # subdir), but w/o `version` the yarn hooks refuse to run.
    jq '.version = "${version}"' < package.json | sponge package.json

    # This replaces a version check by accessing package.json, which
    # in the nix packaging is not at the expected path
    substituteInPlace packages/web/nextjs/next.config.js \
      --replace-fail '@NIX_LOG4BRAINS_VERSION@' '${version}'
  '';

  # = Notes =
  #
  # Not copying the full node_modules yields:
  # Error: Cannot find module 'chalk'
  #
  # The log4brains version in src/ and the default install differ,
  # hence remove the copied version and let installPhase handle it.
  #
  # Setting `yarnKeepDevDeps = true` does not retain all required dependencies.
  #
  # An alternative approach is to bundle log4brains binary using (tested only in devshell):
  # npx pkg --target 'node*-linux-x64' .
  preInstall = ''
    mkdir -p $out/lib
    cp -aLrt $out/lib ../../node_modules

    # will get installed by the installPhase, so avoid conflicts
    rm -r $out/lib/node_modules/log4brains
  '';

  installPhase = ''
    # the desired final package is inside of a subdir; switch there
    pushd packages/global-cli

    # pre/postinstall hooks are part of yarnInstallHook
    yarnInstallHook

    popd
  '';

  # w/o yarn it just generated cryptic errors ENOENT
  #
  # There are some builds at runtime (marked as "hack" in the src),
  # hence we need node_modules set
  postInstall = ''
    wrapProgram $out/bin/log4brains \
      --suffix PATH : ${
        lib.makeBinPath [
          nodejs
          yarn
        ]
      } \
      --set-default NODE_PATH $out/lib/node_modules
  '';

  nativeBuildInputs = [
    yarnConfigHook
    yarnBuildHook
    yarnInstallHook
    # Needed for executing package.json scripts
    nodejs

    makeWrapper

    moreutils # sponge
    jq
  ];

  passthru.tests.basic-scenario = callPackage ./test-basic-scenario.nix { };

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
