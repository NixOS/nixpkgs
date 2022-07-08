{ lib
, vscode-utils
, icu
, python3
  # When `true`, the python default setting will be fixed to specified.
  # Use version from `PATH` for default setting otherwise.
  # Defaults to `false` as we expect it to be project specific most of the time.
, pythonUseFixed ? false
}:

vscode-utils.buildVscodeMarketplaceExtension {
  mktplcRef = {
    name = "python";
    publisher = "ms-python";
    version = "2022.11.11881005";
    sha256 = "sha256-8NH/aWIAwSpVRi3cvBCpvO8MVzIoRaXxADmWp6DuUb8=";
  };

  buildInputs = [ icu ];

  nativeBuildInputs = [ python3.pkgs.wrapPython ];

  propagatedBuildInputs = with python3.pkgs; [
    debugpy
    isort
    jedi-language-server
  ];

  postPatch = ''
    # remove bundled python deps and use libs from nixpkgs
    rm -r pythonFiles/lib
    mkdir -p pythonFiles/lib/python/
    ln -s ${python3.pkgs.debugpy}/lib/*/site-packages/debugpy pythonFiles/lib/python/
    buildPythonPath "$propagatedBuildInputs"
    for i in pythonFiles/*.py; do
      patchPythonScript "$i"
    done
  '' + lib.optionalString pythonUseFixed ''
    # Patch `packages.json` so that nix's *python* is used as default value for `python.pythonPath`.
    substituteInPlace "./package.json" \
      --replace "\"default\": \"python\"" "\"default\": \"${python3.interpreter}\""
  '';

  meta = with lib; {
    license = licenses.mit;
    platforms = [ "x86_64-linux" "aarch64-darwin" "x86_64-darwin" ];
    maintainers = with maintainers; [ jraygauthier jfchevrette ];
  };
}
