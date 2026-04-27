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
  version = "4.6.0";

  src = fetchFromGitHub {
    owner = "grocy";
    repo = "grocy";
    tag = "v${finalAttrs.version}";
    hash = "sha256-qdN+stXuwChv6IaFSX2SrSdej7Id/M0UaO2cggAvWdc=";
  };

  vendorHash = "sha256-3f7me/YG2lt7fhkgXO1+0SXO+1IK+Fdb3/gywWyaxVg=";

  offlineCache = fetchYarnDeps {
    yarnLock = finalAttrs.src + "/yarn.lock";
    hash = "sha256-48+u0NYZZiYvP2ADAkRdL079wmjWMHwPHi8rlDP41Eo=";
  };

  nativeBuildInputs = [
    yarn
    fixup-yarn-lock
  ];

  # Upstream composer.json file is missing the name, description and license fields
  composerStrictValidation = false;

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
