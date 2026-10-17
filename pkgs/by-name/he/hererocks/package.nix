{
  lib,
  nix-update-script,
  fetchFromGitHub,
  python3Packages,
  gcc,
  git,
}:
python3Packages.buildPythonApplication rec {
  pname = "hererocks";
  version = "0.25.1";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "luarocks";
    repo = "hererocks";
    tag = "${version}";
    hash = "sha256-y28MTFncy5oD57jpY6AN+X/58OzY3ae3rSL236rfuL0=";
  };

  build-system = with python3Packages; [
    setuptools
  ];

  # No tests
  doCheck = false;

  pythonImportsCheck = [ "hererocks" ];

  makeWrapperArgs = [
    "--prefix PATH : ${
      lib.makeBinPath [
        gcc
        git
      ]
    }"
  ];

  passthru.updateScript = nix-update-script { };

  meta = {
    description = "Tool for installing Lua and LuaRocks locally";
    homepage = "https://github.com/luarocks/hererocks";
    changelog = "https://github.com/luarocks/hererocks/blob/${version}/CHANGELOG.md";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ theobori ];
    mainProgram = "hererocks";
  };
}
