{
  stdenv,
  lib,
  vscode-utils,
  icu,
  python3,
  # When `true`, the python default setting will be fixed to specified.
  # Use version from `PATH` for default setting otherwise.
  # Defaults to `false` as we expect it to be project specific most of the time.
  pythonUseFixed ? false,
  # For updateScript
  vscode-extension-update-script,
}:

let
  supported = {
    x86_64-linux = {
      hash = "sha256-5hhzI6m5TY6tk75Qv80yCuOTgspxyUwqJM5gPnQOs94=";
      arch = "linux-x64";
    };
    x86_64-darwin = {
      hash = "sha256-4Ff4FxEosD0osMf3SKlghHBPnwI5pGRgjM2Yst1rSog=";
      arch = "darwin-x64";
    };
    aarch64-linux = {
      hash = "sha256-8eNuhzHIg4sK8/xyWPnZ2IZ7rZ9Fs9uTqtVNoO1T0Ds=";
      arch = "linux-arm64";
    };
    aarch64-darwin = {
      hash = "sha256-ZvIE1e+sg7m2baWjc455LcJuT5M2Pe1v4FbPtbpulN8=";
      arch = "darwin-arm64";
    };
  };

  base =
    supported.${stdenv.hostPlatform.system}
      or (throw "unsupported platform ${stdenv.hostPlatform.system}");

in
vscode-utils.buildVscodeMarketplaceExtension rec {
  mktplcRef = base // {
    name = "python";
    publisher = "ms-python";
    version = "2025.10.1";
  };

  buildInputs = [ icu ];

  nativeBuildInputs = [ python3.pkgs.wrapPython ];

  propagatedBuildInputs = with python3.pkgs; [
    debugpy
    jedi-language-server
  ];

  postPatch = ''
    # remove bundled python deps and use libs from nixpkgs
    rm -r python_files/lib
    mkdir -p python_files/lib/python/
    ln -s ${python3.pkgs.debugpy}/lib/*/site-packages/debugpy python_files/lib/python/
    buildPythonPath "$propagatedBuildInputs"
    for i in python_files/*.py; do
      patchPythonScript "$i"
    done
  ''
  + lib.optionalString pythonUseFixed ''
    # Patch `packages.json` so that nix's *python* is used as default value for `python.pythonPath`.
    substituteInPlace "./package.json" \
      --replace-fail "\"default\":\"python\"" "\"default\":\"${python3.interpreter}\""
  '';

  passthru.updateScript = vscode-extension-update-script { };

  meta = {
    description = "Visual Studio Code extension with rich support for the Python language";
    downloadPage = "https://marketplace.visualstudio.com/items?itemName=ms-python.python";
    homepage = "https://github.com/Microsoft/vscode-python";
    changelog = "https://github.com/microsoft/vscode-python/releases";
    license = lib.licenses.mit;
    platforms = builtins.attrNames supported;
    maintainers = [
      lib.maintainers.jraygauthier
      lib.maintainers.jfchevrette
    ];
  };
}
