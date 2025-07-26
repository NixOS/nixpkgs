{
  lib,
  python3Packages,
  fetchgit,
  kustomize,
  fluxcd,
  kubernetes-helm,
}:
python3Packages.buildPythonPackage rec {
  pname = "flux-local";
  version = "7.7.0";
  pyproject = true;

  src = fetchgit {
    url = "https://github.com/allenporter/flux-local";
    rev = version;
    hash = "sha256-Ms6h1sieZYb0/8IdpESyb1NLolPh8UCAYbbPfdtJUWA=";
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
    pytest # Used by `flux-local test` command.
    pytest-asyncio
    oras
    python-slugify
  ];

  doCheck = true;

  # Do not treat syrupy out-of-date snapshot as an error.
  pytestFlags = [ "--snapshot-warn-unused" ];

  disabledTests = [
    # Requires network
    "test_oci_repository[oci_repo_dir0-release_dir0]"
    "test_test_hr[cluster]"
    "test_test_hr[cluster2]"
    "test_test_hr[cluster3]"
    "test_test_hr[cluster9]"
    "test_template[helm_repo_dir0-release_dir0]"
    # Test expects output to be "kustomize" for KUSTOMIZE_BIN, but we patched this to "/nix/store/.../bin/kustomize".
    "test_internal_commands"
  ];

  nativeCheckInputs = with python3Packages; [
    pytestCheckHook
    syrupy
  ];

  buildInputs = [
    kustomize
    fluxcd
    kubernetes-helm
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
