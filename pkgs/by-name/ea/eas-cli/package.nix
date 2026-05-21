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
  patches = [
    # Remove after upstream updates to Yarn 4.14
    # https://github.com/expo/eas-cli/blob/v18.7.0/package.json#L37
    ./yarn-4.14-support.patch
  ];
in
# cc is necessary because of building an npm package without a prebuilt binary
#  for ARM. See comment in nativeBuildInputs below.
stdenv.mkDerivation (finalAttrs: {
  pname = "eas-cli";
  inherit
    src
    version
    missingHashes
    patches
    ;

  yarnOfflineCache = yarn-berry_4.fetchYarnBerryDeps {
    inherit src missingHashes patches;
    hash = "sha256-KtFLJc2bEBS0sgTqbF68574fFMxwSlaSKcR0RedVJ4k=";
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

  # yarnInstallHook strips out build outputs within packages/eas-cli resulting in most commands missing from eas-cli.
  installPhase = ''
    runHook preInstall

    mkdir -p $out/lib/node_modules/eas-cli-root
    cp -r . $out/lib/node_modules/eas-cli-root

    runHook postInstall
  '';

  # postFixup is used to override the symlink created in the fixupPhase
  postFixup = ''
    mkdir -p $out/bin
    ln -sf $out/lib/node_modules/eas-cli-root/packages/eas-cli/bin/run $out/bin/eas
    wrapProgram $out/bin/eas --suffix PATH : ${lib.makeBinPath [ nodejs ]}
  '';

  meta = {
    changelog = "https://github.com/expo/eas-cli/releases/tag/v${finalAttrs.version}";
    description = "EAS command line tool from submodule";
    homepage = "https://github.com/expo/eas-cli";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ zestsystem ];
  };
})
