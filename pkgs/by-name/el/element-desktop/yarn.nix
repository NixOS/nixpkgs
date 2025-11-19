{
  stdenvNoCC,
  nodejs,
  yarn,
  cacert,
  git,
  version,
  src,
  hash,
}:
stdenvNoCC.mkDerivation {
  pname = "element-desktop-yarn-deps";
  inherit version src;

  nativeBuildInputs = [
    cacert
    nodejs
    yarn
    git
  ];

  dontInstall = true;

  NODE_EXTRA_CA_CERTS = "${cacert}/etc/ssl/certs/ca-bundle.crt";

  buildPhase = ''
    export HOME=$(mktemp -d)
    export YARN_ENABLE_TELEMETRY=0

    yarn install --frozen-lockfile --ignore-platform --skip-integrity-check --ignore-scripts --no-progress --non-interactive
    # Apply upstream patch
    # Can be removed if upstream removes patches/@types+auto-launch+5.0.5.patch introduced in
    # https://github.com/element-hq/element-desktop/commit/5e882f8e08d58bf9663c8e3ab33885bf7b3709de
    node ./node_modules/patch-package/index.js

    mkdir -p $out/node_modules
    cp -r node_modules/* $out/node_modules/
  '';

  dontPatchShebangs = true;

  outputHash = hash;
  outputHashMode = "recursive";
}
