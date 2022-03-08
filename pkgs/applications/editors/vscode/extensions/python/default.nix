{ lib, stdenv, fetchurl, vscode-utils, extractNuGet
, icu, curl, openssl, liburcu, lttng-ust, autoPatchelfHook
, python3, musl
, pythonUseFixed ? false       # When `true`, the python default setting will be fixed to specified.
                               # Use version from `PATH` for default setting otherwise.
                               # Defaults to `false` as we expect it to be project specific most of the time.
, ctagsUseFixed ? true, ctags  # When `true`, the ctags default setting will be fixed to specified.
                               # Use version from `PATH` for default setting otherwise.
                               # Defaults to `true` as usually not defined on a per projet basis.
}:

assert ctagsUseFixed -> null != ctags;

let
  liburcu-0-12 = liburcu.overrideAttrs (oldAttrs: rec {
    version = "0.12.2";
    src = fetchurl {
      url = "https://lttng.org/files/urcu/userspace-rcu-${version}.tar.bz2";
      sha256 = "0yx69kbx9zd6ayjzvwvglilhdnirq4f1x1sdv33jy8bc9wgc3vsf";
    };
  });

  lttng-ust-2-10 = (lttng-ust.override {
    liburcu = liburcu-0-12;
  }).overrideAttrs (oldAttrs: rec {
    version = "2.10.5";
    src = fetchurl {
      url = "https://lttng.org/files/lttng-ust/lttng-ust-${version}.tar.bz2";
      sha256 = "0ddwk0nl28bkv2xb78gz16a2bvlpfbjmzwfbgwf5p1cq46dyvy86";
    };
  });

  pythonDefaultsTo = if pythonUseFixed then "${python3}/bin/python" else "python";
  ctagsDefaultsTo = if ctagsUseFixed then "${ctags}/bin/ctags" else "ctags";

  # The arch tag comes from 'PlatformName' defined here:
  # https://github.com/Microsoft/vscode-python/blob/master/src/client/activation/types.ts
  arch =
    if stdenv.isLinux && stdenv.isx86_64 then "linux-x64"
    else if stdenv.isDarwin then "osx-x64"
    else throw "Only x86_64 Linux and Darwin are supported.";

  languageServerSha256 = {
    linux-x64 = "1pmj5pb4xylx4gdx4zgmisn0si59qx51n2m1bh7clv29q6biw05n";
    osx-x64 = "0ishiy1z9dghj4ryh95vy8rw0v7q4birdga2zdb4a8am31wmp94b";
  }.${arch};

  # version is languageServerVersion in the package.json
  languageServer = extractNuGet rec {
    name = "Python-Language-Server";
    version = "0.5.30";

    src = fetchurl {
      url = "https://pvsc.azureedge.net/python-language-server-stable/${name}-${arch}.${version}.nupkg";
      sha256 = languageServerSha256;
    };
  };
in vscode-utils.buildVscodeMarketplaceExtension rec {
  mktplcRef = {
    name = "python";
    publisher = "ms-python";
    version = "2022.0.1814523869";
  };

  vsix = fetchurl {
    name = "${mktplcRef.publisher}-${mktplcRef.name}.zip";
    url = "https://github.com/microsoft/vscode-python/releases/download/${mktplcRef.version}/ms-python-release.vsix";
    sha256 = "sha256-JDaimcOUDo9GuFA3mhbbGLwqZE9ejk8pWYc+9PrRhVk=";
  };

  buildInputs = [
    icu
    curl
    openssl
  ] ++ lib.optionals stdenv.isLinux [
    lttng-ust-2-10
    musl
  ];

  nativeBuildInputs = [
    python3.pkgs.wrapPython
  ] ++ lib.optionals stdenv.isLinux [
    autoPatchelfHook
  ];

  pythonPath = with python3.pkgs; [
    setuptools
  ];

  postPatch = ''
    # Patch `packages.json` so that nix's *python* is used as default value for `python.pythonPath`.
    substituteInPlace "./package.json" \
      --replace "\"default\": \"python\"" "\"default\": \"${pythonDefaultsTo}\""

    # Patch `packages.json` so that nix's *ctags* is used as default value for `python.workspaceSymbols.ctagsPath`.
    substituteInPlace "./package.json" \
      --replace "\"default\": \"ctags\"" "\"default\": \"${ctagsDefaultsTo}\""

    # Similar cleanup to what's done in the `debugpy` python package.
    # This prevent our autopatchelf logic to bark on unsupported binaries (`attach_x86.so`
    # was problematic) but also should make our derivation less heavy.
    (
      cd pythonFiles/lib/python/debugpy/_vendored/pydevd/pydevd_attach_to_process
      declare kept_aside="${{
        "x86_64-linux" = "attach_linux_amd64.so";
        "aarch64-darwin" = "attach_x86_64.dylib";
        "x86_64-darwin" = "attach_x86_64.dylib";
      }.${stdenv.hostPlatform.system} or (throw "Unsupported system: ${stdenv.hostPlatform.system}")}"
      mv "$kept_aside" "$kept_aside.hidden"
      rm *.so *.dylib *.dll *.exe *.pdb
      mv "$kept_aside.hidden" "$kept_aside"
    )
  '';

  postInstall = ''
    mkdir -p "$out/$installPrefix/languageServer.${languageServer.version}"
    cp -R --no-preserve=ownership ${languageServer}/* "$out/$installPrefix/languageServer.${languageServer.version}"
    chmod -R +wx "$out/$installPrefix/languageServer.${languageServer.version}"

    patchPythonScript "$out/$installPrefix/pythonFiles/lib/python/isort/main.py"
  '';

  meta = with lib; {
    license = licenses.mit;
    platforms = [ "x86_64-linux" "aarch64-darwin" "x86_64-darwin" ];
    maintainers = with maintainers; [ jraygauthier jfchevrette ];
  };
}
