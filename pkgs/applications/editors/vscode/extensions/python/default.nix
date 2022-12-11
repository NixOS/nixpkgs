{ lib
, vscode-utils
, icu
, python3
  # When `true`, the python default setting will be fixed to specified.
  # Use version from `PATH` for default setting otherwise.
  # Defaults to `false` as we expect it to be project specific most of the time.
, pythonUseFixed ? false
  # For updateScript
, writeScript
, bash
, curl
, coreutils
, gnused
, nix
}:

vscode-utils.buildVscodeMarketplaceExtension rec {
  mktplcRef = {
    name = "python";
    publisher = "ms-python";
    version = "2022.17.13011006";
    sha256 = "sha256-f5vbXcqKwCnL+vsTcOX7rWUfoXNih5ZaWr3XUpCYB/M=";
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

  passthru.updateScript = writeScript "update" ''
    #! ${bash}/bin/bash

    set -eu -o pipefail

    export PATH=${lib.makeBinPath [
      curl
      coreutils
      gnused
      nix
    ]}

    api=$(curl -s 'https://marketplace.visualstudio.com/_apis/public/gallery/extensionquery' \
      -H 'accept: application/json;api-version=3.0-preview.1' \
      -H 'content-type: application/json' \
      --data-raw '{"filters":[{"criteria":[{"filterType":7,"value":"${mktplcRef.publisher}.${mktplcRef.name}"}]}],"flags":512}')
    version=$(echo $api | sed -n -E 's|^.*"version":"([0-9.]+)".*$|\1|p')

    if [[ $version != ${mktplcRef.version} ]]; then
      tmp=$(mktemp)
      curl -sLo $tmp $(echo ${(import ../mktplcExtRefToFetchArgs.nix mktplcRef).url} | sed "s|${mktplcRef.version}|$version|")
      hash=$(nix hash file --type sha256 --base32 --sri $tmp)
      sed -i -e "s|${mktplcRef.sha256}|$hash|" -e "s|${mktplcRef.version}|$version|" pkgs/applications/editors/vscode/extensions/python/default.nix
    fi
  '';

  meta = with lib; {
    description = "A Visual Studio Code extension with rich support for the Python language";
    downloadPage = "https://marketplace.visualstudio.com/items?itemName=ms-python.python";
    homepage = "https://github.com/Microsoft/vscode-python";
    changelog = "https://github.com/microsoft/vscode-python/releases";
    license = licenses.mit;
    platforms = [ "x86_64-linux" "aarch64-darwin" "x86_64-darwin" ];
    maintainers = with maintainers; [ jraygauthier jfchevrette ];
  };
}
