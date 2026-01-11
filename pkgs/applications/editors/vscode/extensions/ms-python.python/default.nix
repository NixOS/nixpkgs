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
      hash = "sha256-MJ5FI1YbvknhuBgSQIpd/s4fyIvaOZHTQBeGxBo1uhs=";
      arch = "linux-x64";
    };
    x86_64-darwin = {
      hash = "sha256-Jk41L8QulT+olJxUl1E/UOOtD/qIIiwSlkP5R9qOJhU=";
      arch = "darwin-x64";
    };
    aarch64-linux = {
      hash = "sha256-xeD73t9WleBz/p+DyIs9vRUlKcbzUwL1RxILNKOi+14=";
      arch = "linux-arm64";
    };
    aarch64-darwin = {
      hash = "sha256-gRViqhIyqmUId56lf8o6z9KK4rNK5Ufg9i2gecsTrVc=";
      arch = "darwin-arm64";
    };
  };

  base =
    supported.${stdenv.hostPlatform.system}
      or (throw "unsupported platform ${stdenv.hostPlatform.system}");

in
vscode-utils.buildVscodeMarketplaceExtension {
  mktplcRef = base // {
    name = "python";
    publisher = "ms-python";
    version = "2025.16.0";
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
