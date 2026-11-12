{
  lib,
  fetchFromGitHub,
  fetchYarnDeps,
  php85,
  yarn,
  fixup-yarn-lock,
  nixosTests,
}:
let
  php = php85;
in
php.buildComposerProject2 (finalAttrs: {
  pname = "grocy";
  version = "4.7.1";

  src = fetchFromGitHub {
    owner = "grocy";
    repo = "grocy";
    tag = "v${finalAttrs.version}";
    hash = "sha256-WhGXMQfc8yHc2B8YBuoVhGjj33Uj8NOdM1hG48bPBrg=";
  };

  # Upstream composer.json file is missing the name, description and license fields
  composerStrictValidation = false;
  vendorHash = "sha256-mxZcRga2mUyZPyvy77H5INF8tDr/UEj4hw+DhIL9o6M=";

  offlineCache = fetchYarnDeps {
    yarnLock = finalAttrs.src + "/yarn.lock";
    hash = "sha256-NnAhw53Ojh0VGWOkwlOoN8mm7/BOUutgV87/Z14dfxg=";
  };

  nativeBuildInputs = [
    yarn
    fixup-yarn-lock
  ];

  # NOTE: if patches are created from a git checkout, those should be modified
  # with `unix2dos` to make sure those apply here.
  patches = [
    ./0001-Define-configs-with-env-vars.patch
    ./0002-Remove-check-for-config-file-as-it-s-stored-in-etc-g.patch
  ];

  configurePhase = ''
    runHook preConfigure

    export HOME=$(mktemp -d)
    yarn config --offline set yarn-offline-mirror $offlineCache
    fixup-yarn-lock yarn.lock
    yarn install --offline --frozen-lockfile --no-progress --non-interactive

    runHook postConfigure
  '';

  postInstall = ''
    chmod -R u+w $out/share
    mv $out/share/php/grocy/* $out
    rm -r $out/share
  '';

  passthru = {
    phpPackage = php;
    tests = { inherit (nixosTests) grocy; };
  };

  meta = {
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ diogotcorreia ];
    description = "ERP beyond your fridge - grocy is a web-based self-hosted groceries & household management solution for your home";
    homepage = "https://grocy.info/";
  };
})
