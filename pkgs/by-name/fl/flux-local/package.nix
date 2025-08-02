{
  lib,
  python3Packages,
  fetchFromGitHub,
  kustomize,
  fluxcd,
  kubernetes-helm,
}:
python3Packages.buildPythonPackage rec {
  pname = "flux-local";
  version = "7.7.0";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "allenporter";
    repo = "flux-local";
    tag = version;
    hash = "sha256-/Lt0bl16GxmnWCQMf10ev/xjcDHi2b04uHy//Yz0zaY=";
    leaveDotGit = true; # Diff tests require exact git history to function.
  };

  build-system = with python3Packages; [
    setuptools
    setuptools-scm
  ];

  dependencies = with python3Packages; [
    aiofiles
    nest-asyncio
    gitpython
    pyyaml
    mashumaro
    pytest # Used by `flux-local test` command, not just a test dependency.
    pytest-asyncio
    oras
    python-slugify
  ];

  buildInputs = [
    kustomize
    fluxcd
    kubernetes-helm
  ];

  nativeCheckInputs = with python3Packages; [
    pytestCheckHook
    syrupy
  ];

  postPatch = ''
    substituteInPlace flux_local/kustomize.py \
      --replace-fail 'KUSTOMIZE_BIN = "kustomize"' 'KUSTOMIZE_BIN = "${kustomize}/bin/kustomize"' \
      --replace-fail 'FLUX_BIN = "flux"' 'FLUX_BIN = "${fluxcd}/bin/flux"'
    substituteInPlace flux_local/helm.py \
      --replace-fail 'HELM_BIN = "helm"' 'HELM_BIN = "${kubernetes-helm}/bin/helm"'
    substituteInPlace tests/tool/__init__.py \
      --replace-fail 'FLUX_LOCAL_BIN = "flux-local"' "FLUX_LOCAL_BIN = \"$out/bin/flux-local\""
  '';

  doCheck = true;

  # Do not treat syrupy out-of-date snapshots as an error.
  pytestFlags = [ "--snapshot-warn-unused" ];

  disabledTests = [
    # Requires network to pull OCI containers.
    "test_oci_repository[oci_repo_dir0-release_dir0]"
    "test_test_hr[cluster]"
    "test_test_hr[cluster2]"
    "test_test_hr[cluster3]"
    "test_test_hr[cluster9]"
    "test_template[helm_repo_dir0-release_dir0]"
    # Auto-generated test-data relying on relative paths we patched to /nix/store paths.
    # Serialization format is hard to patch, so these tests are skipped instead.
    "test_internal_commands"
  ];

  meta = {
    changelog = "https://github.com/pytest-dev/pytest/releases/tag/${version}";
    description = "Set of tools and libraries for managing a local flux gitops repository";
    homepage = "https://github.com/allenporter/flux-local";
    mainProgram = "flux-local";
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [
      soupglasses
    ];
  };
}
