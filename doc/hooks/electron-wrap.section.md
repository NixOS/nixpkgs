# electron.electronWrapHook {#electron-wrap-hook}

Hook for wrapping Electron-based packages.

## Examples {#electron-wrap-hook-example}

:::{.example #electron-wrap-hook-example-snippet}

# Using `electronWrapHook`

Note that how Electron packages are built can vary widely between packages.

```nix
{
  stdenv,
  fetchFromGitHub,
  fetchPnpmDeps,
  pnpmConfigHook,
  pnpm,
  electron,
}:
buildNpmPackage (finalAttrs: {
  pname = "electron-project";
  version = "1.0";

  src = fetchFromGitHub {
    owner = "JaneElectron";
    repo = "ElectronProject";
    tag = finalAttrs.version;
    hash = "...";
  };

  npmDeps = null;
  pnpmDeps = fetchPnpmDeps {
    inherit (finalAttrs) pname version src;
    inherit pnpm;
    fetcherVersion = 3;
    hash = "...";
  };

  npmConfigHook = pnpmConfigHook;

  # Must be in buildInputs since the Electron is the
  # Electron running on the host machine
  buildInputs = [
    electron.electronWrapHook
  ];

  env = {
    ELECTRON_SKIP_BINARY_DOWNLOAD = 1;
  };

  postBuild = ''
    cp -r ${electron.dist} electron-dist
    chmod -R u+w electron-dist

    npm_config_nodedir=${electron.headers} \
    npm exec electron-builder -- \
      --config electron-builder.json \
      --dir \
      -c.electronDist=electron-dist
      -c.electronVersion=${electron.version}
  '';

  installPhase = ''
    runHook preInstall

    mkdir -p "$out/share"

    cp -r dist/resources $out/share/electron-program

    runHook postInstall
  '';

  meta = {
    mainProgram = "electronProject";
    description = "electron project";
  };
})
```
:::

## Variables controlling `electronWrapHook` {#electron-wrap-hook-variables}

### `electronWrapHook` Exclusive Variables {#electron-wrap-hook-exclusive-variables}

#### `electronWrapPath` {#electron-wrap-hook-path}

Controls the path that is wrapped by Electron.
Most often this is a `*.asar` archive that is automatically found by the hook.
But in some cases this will need to be manually provided:

1. If there are multiple `*.asar` archives in one package
2. If a `*.asar` archive was not generated

Archives are not always generated, often in cases when `asar=false` is passed to `electron-builder` (if used),
or if `electron-pacakger` is used and `asar=true` is not passed. In that case the path that is wrapped will be
a directory, not an archive file.

#### `electronWrapperName` {#electron-wrap-hook-name}

Controls the name of the wrapper program.
This will be output to `{!outputBin}/bin/$name`, which is either `$bin` or `$out` in that order of precedence.
Often does not need to be set, and `meta.mainProgram` should be set instead.
Only set this if the Electron program is not the *main* program of the package.

#### `electronWrapperArgs` {#electron-wrap-hook-args}

Controls the arguments to `makeWrapper`.

Default flags:
- `--inherit-argv0`
- `--set-default ELECTRON_FORCE_IS_PACKAGED 1`
- The `*.asar` file to wrap

If for example this Electron program requires arguments from other toolkits, those flags can be appended like so:

```nix
{
  #...
  dontWrapGApps = true;
  preInstall = ''
    electronWrapperArgs+=("''${gappsWrapperArgs[@]}")
  '';
  #...
}
```
#### `dontElectronWrap` {#electron-wrap-hook-dont}

Control whether the hook is ran or not. Defaults to `true`.

If set to false, the hook will not do any detection.
This is useful for manually wrapping paths using the wrapper manually.

The wrapper as two required arguments, and then optional arguments.

1. The path to wrap, generally a `*.asar` file
2. The path to place the wrapper.
3. All other argument will be appended to the `makeWrapper` call.

```nix
{
  dontElectronWrap = true;
  postInstall = ''
    mkdir -p "$out/bin"
    electronWrap "$out/share/myApp/app.asar" "$out/bin/myApp" --set SOME_ENV 1
  '';
}
```
