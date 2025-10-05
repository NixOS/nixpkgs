{
  stdenvNoCC,
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
    yarn
    git
  ];

  dontInstall = true;

  NODE_EXTRA_CA_CERTS = "${cacert}/etc/ssl/certs/ca-bundle.crt";

  buildPhase = ''
    export HOME=$(mktemp -d)
    export YARN_ENABLE_TELEMETRY=0

    yarn install --frozen-lockfile --ignore-platform --skip-integrity-check --ignore-scripts --no-progress --non-interactive

    mkdir -p $out/node_modules
    cp -r node_modules/* $out/node_modules/
  '';

  dontPatchShebangs = true;

  outputHash = hash;
  outputHashMode = "recursive";
}
