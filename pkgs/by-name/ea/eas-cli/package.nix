{
  lib,
  stdenv,
  fetchFromGitHub,
  yarn-berry_4,
  nodejs,
  jq,
  makeWrapper,
  pkg-config,
  python3,
  runCommand,
  eas-cli,
}:
let
  version = "18.7.0";
  src = fetchFromGitHub {
    owner = "expo";
    repo = "eas-cli";
    rev = "v${version}";
    hash = "sha256-Z+PtS88Rv9Vv6FA15KxSBWCmOtwmTqO1etgCV7WaTXo=";
  };
  missingHashes = ./missing-hashes.json;
in
# cc is necessary because of building an npm package without a prebuilt binary
#  for ARM. See comment in nativeBuildInputs below.
stdenv.mkDerivation (finalAttrs: {
  pname = "eas-cli";
  inherit src version missingHashes;

  yarnOfflineCache = yarn-berry_4.fetchYarnBerryDeps {
    inherit src missingHashes;
    hash = "sha256-ZlbCHWEwVaYCfzowrm1qrM1MpLo5vNmEG5bWzWT/cTU=";
  };

  nativeBuildInputs = [
    yarn-berry_4
    yarn-berry_4.yarnBerryConfigHook
    nodejs
    jq
    makeWrapper
  ]
  ++ lib.optionals stdenv.hostPlatform.isAarch64 [
    # The version of utf-8-validate -> node-gyp -> bufferutil that this package
    #  uses not have pre-built binary for ARM. It appears that this should be
    #  fixed by the version of utf-8-validate that this depends on, so there
    #  may be some underlying transitive dependency causing this.
    #  https://github.com/websockets/utf-8-validate/issues/106
    pkg-config
    python3
  ];

  postPatch = ''
    # Disable Nx integration in Lerna to avoid the native pseudo terminal panic in the sandbox.
    tmpfile="$(mktemp)"
    jq '.useNx = false' lerna.json > "$tmpfile"
    mv "$tmpfile" lerna.json
  '';

  buildPhase = ''
    runHook preBuild
    yarn build
    runHook postBuild
  '';

  # yarnInstallHook strips out build outputs within packages/eas-cli resulting in most commands missing from eas-cli.
  installPhase = ''
    runHook preInstall

    mkdir -p $out/lib/node_modules/eas-cli-root
    cp -r . $out/lib/node_modules/eas-cli-root

    mkdir -p $out/bin
    patchShebangs $out/lib/node_modules/eas-cli-root/packages/eas-cli/bin/run
    ln -sf $out/lib/node_modules/eas-cli-root/packages/eas-cli/bin/run $out/bin/eas

    runHook postInstall
  '';

  passthru.tests = {
    # CLI command registration is dynamic. There have been multiple issues
    # where the build succeeds and the CLI executes, but the author does not
    # catch that the install caused command registration to fail. This tests
    # that a TOPICS section exists. In the previous failure modes, only a
    # COMMAND section exists.
    check-topics = runCommand "${finalAttrs.pname}-check-topics" { nativeBuildInputs = [ eas-cli ]; } ''
      if eas | grep -q "^TOPICS$"; then
          touch $out
      fi
    '';
  };

  meta = {
    changelog = "https://github.com/expo/eas-cli/releases/tag/v${finalAttrs.version}";
    description = "EAS command line tool from submodule";
    homepage = "https://github.com/expo/eas-cli";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ zestsystem ];
  };
})
