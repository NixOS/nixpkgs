{
  lib,
  bash,
  coreutils,
  fetchFromGitHub,
  python3Packages,
  shadow-network-simulator,
}:

python3Packages.buildPythonApplication (finalAttrs: {
  pname = "shadowtools";
  version = "3.3.0";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "shadow";
    repo = "shadow";
    rev = "v${finalAttrs.version}";
    hash = "sha256-kgWvrnpWUJ5OWy2+luju8SHDRcveVbdfCKntDgxVj0o=";
  };

  __structuredAttrs = true;

  postUnpack = ''
    sourceRoot="$sourceRoot/shadowtools"
  '';

  postPatch = ''
    # Upstream currently ships `shadowtools` from the Shadow release tarball but
    # leaves its Python package version at a placeholder `0.0.1`.
    # Patch it to the corresponding Shadow release so the built metadata matches
    # the source we are packaging.
    substituteInPlace pyproject.toml \
      --replace-fail 'version = "0.0.1"' 'version = "${finalAttrs.version}"'

    # `shadow-exec` runs commands through a managed `bash` process inside Shadow.
    # In regular distro environments that shell tends to have a usable default
    # search path, but the Nix-packaged `bash` does not. Forward the launcher's
    # PATH into the managed process so wrapped runtime tools such as `shadow`,
    # `bash`, and basic coreutils commands are available there as well.
    oldProcessDef=$'path="bash",\n                        args=['
    newProcessDef=$'environment={"PATH":os.environ.get("PATH","")},path="bash",\nargs=['

    substituteInPlace src/shadowtools/shadow_exec.py \
      --replace-fail 'import argparse' \
        $'import argparse\nimport os' \
      --replace-fail "$oldProcessDef" "$newProcessDef"
  '';

  build-system = with python3Packages; [ setuptools ];

  dependencies = with python3Packages; [ pyyaml ];

  nativeCheckInputs = with python3Packages; [ pytestCheckHook ];

  makeWrapperArgs = [
    "--prefix"
    "PATH"
    ":"
    (lib.makeBinPath [
      bash
      coreutils
      shadow-network-simulator
    ])
  ];

  pythonImportsCheck = [
    "shadowtools.config"
    "shadowtools.shadow_exec"
  ];

  # Upstream's tests run real Shadow simulations. Those start by reading host
  # CPU topology from `/sys/devices/system/cpu/online`, which is unavailable in
  # the Nix build sandbox, so the test suite aborts before reaching the Python
  # assertions. Keep the package-level smoke test to remote/manual validation
  # outside the sandbox instead.
  doCheck = false;

  meta = {
    description = "Python tools for the Shadow network simulator";
    homepage = "https://shadow.github.io/";
    changelog = "https://github.com/shadow/shadow/releases/tag/v${finalAttrs.version}";
    license = lib.licenses.bsd3;
    mainProgram = "shadow-exec";
    maintainers = with lib.maintainers; [ starius ];
    platforms = [ "x86_64-linux" ];
  };
})
