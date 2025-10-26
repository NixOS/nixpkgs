{
  stdenv,
  fetchPypi,
  fetchurl,
  installShellFiles,
  lib,
  python3Packages,
}:

let
  hash = "sha256-QQxadKVEIh1PvD8FdYgJ/U1iyWdy6FvO+LUELQ70KKw=";
  # specVersion taken from: https://www.linode.com/docs/api/openapi.yaml at `info.version`.
  specVersion = "4.176.0";
  specHash = "sha256-P1E8Ga5ckrsw/CX0kxFef5fe8/p/pDCLuleX9wR5l48=";
  spec = fetchurl {
    url = "https://raw.githubusercontent.com/linode/linode-api-docs/v${specVersion}/openapi.yaml";
    hash = specHash;
  };

in

python3Packages.buildPythonApplication (finalAttrs: {
  pname = "linode-cli";
  version = "5.56.2";
  pyproject = true;

  src = fetchPypi {
    pname = "linode_cli";
    inherit (finalAttrs) version;
    hash = hash;
  };

  build-system = [
    python3Packages.setuptools
  ];

  patches = [ ./remove-update-check.patch ];

  # remove need for git history
  prePatch = ''
    substituteInPlace setup.py \
      --replace "version = get_version()" "version='${finalAttrs.version}',"
  '';

  postConfigure = ''
    python3 -m linodecli bake ${spec} --skip-config
    cp data-3 linodecli/
    echo "${finalAttrs.version}" > baked_version
  '';

  nativeBuildInputs = [ installShellFiles ];

  dependencies = [
    python3Packages.colorclass
    python3Packages.linode-metadata
    python3Packages.pyyaml
    python3Packages.requests
    python3Packages.terminaltables
    python3Packages.rich
    python3Packages.openapi3
    python3Packages.packaging
  ];

  doInstallCheck = true;
  installCheckPhase = ''
    $out/bin/linode-cli --skip-config --version | grep ${finalAttrs.version} > /dev/null
  '';

  postInstall = lib.optionalString (stdenv.buildPlatform.canExecute stdenv.hostPlatform) ''
    for shell in bash fish; do
      installShellCompletion --cmd linode-cli \
        --$shell <($out/bin/linode-cli --skip-config completion $shell)
      done
  '';

  passthru.updateScript = ./update.sh;

  meta = {
    description = "Linode Command Line Interface";
    changelog = "https://github.com/linode/linode-cli/releases/tag/v${finalAttrs.version}";
    downloadPage = "https://pypi.org/project/linode-cli";
    homepage = "https://github.com/linode/linode-cli";
    license = lib.licenses.bsd3;
    maintainers = with lib.maintainers; [
      ryantm
      techknowlogick
    ];
    mainProgram = "linode-cli";
  };
})
