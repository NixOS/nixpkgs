{
  lib,
  stdenv,
  stdenvNoCC,
  fetchFromGitHub,
  nodejs_22,
  electron_37-bin,
  prefetch-npm-deps,
  vscode-generic,
  writableTmpDirAsHomeHook,
  which,
  jq,
  pkg-config,
  krb5,
  node-gyp,
  writeShellScriptBin,
  cctools,
  xcbuild,
  clang_19,
  ripgrep,
  runCommand,
  libsecret,
  xorg,
  vscode-extensions,
  commandLineArgs ? "",
  useVSCodeRipgrep ? false,
}:
let
  inherit (stdenv) hostPlatform;
  inherit (hostPlatform.node) arch platform;
  commitInfo = lib.importJSON ./commit.json;
  nodejs = nodejs_22;
  electron = electron_37-bin;
  electron-dist-zip = electron_37-bin.src;
  cache-dir =
    if hostPlatform.isDarwin then
      "$HOME/Library/Caches"
    else if hostPlatform.isLinux then
      "$HOME/.cache"
    else
      throw "Unknown platform: ${platform}";

  ripgrep-tgz = runCommand "ripgrep-${ripgrep.version}.tar.gz" { } ''
    tar -czf $out -C ${ripgrep}/bin rg
  '';
  ripgrep-scripts =
    let
      vscode-ripgrep-package-version = "1.15.14";
      # see https://github.com/microsoft/vscode-ripgrep/blob/v1.15.14/lib/postinstall.js#L21
      version = "v13.0.0-13";
      multi_arch_linux_version = "v13.0.0-4";
      # see https://github.com/microsoft/vscode-ripgrep/blob/v1.15.14/lib/postinstall.js#L29-L51
      target =
        if platform == "darwin" then
          (if arch == "arm64" then "aarch64-apple-darwin" else "x86_64-apple-darwin")
        else if platform == "win32" then
          (
            if arch == "x64" then
              "x86_64-pc-windows-msvc"
            else if arch == "arm64" then
              "aarch64-pc-windows-msvc"
            else
              "i686-pc-windows-msvc"
          )
        else if platform == "linux" then
          (
            if arch == "x64" then
              "x86_64-unknown-linux-musl"
            else if arch == "arm" then
              "arm-unknown-linux-gnueabihf"
            else if arch == "armv7l" then
              "arm-unknown-linux-gnueabihf"
            else if arch == "arm64" then
              "aarch64-unknown-linux-musl"
            else if arch == "ppc64" then
              "powerpc64le-unknown-linux-gnu"
            else if arch == "riscv64" then
              "riscv64gc-unknown-linux-gnu"
            else if arch == "s390x" then
              "s390x-unknown-linux-gnu"
            else
              "i686-unknown-linux-musl"
          )
        else
          throw "Unknown platform: ${platform}";
      # see https://github.com/microsoft/vscode-ripgrep/blob/v1.15.14/lib/download.js#L323
      ext = if platform == "win32" then "zip" else "tar.gz";
      # see https://github.com/microsoft/vscode-ripgrep/blob/v1.15.14/lib/postinstall.js#L106
      version' =
        if
          target == "arm-unknown-linux-gnueabihf"
          || target == "powerpc64le-unknown-linux-gnu"
          || target == "s390x-unknown-linux-gnu"
        then
          multi_arch_linux_version
        else
          version;
    in
    ''
      mkdir $TMPDIR/vscode-ripgrep-cache-${vscode-ripgrep-package-version}
      ln -s ${ripgrep-tgz} $TMPDIR/vscode-ripgrep-cache-${vscode-ripgrep-package-version}/ripgrep-${version'}-${target}.${ext}
    '';

  code-oss-build = stdenv.mkDerivation (finalAttrs: {
    pname = "code-oss";
    version = "1.104.3";

    src = fetchFromGitHub {
      owner = "microsoft";
      repo = "vscode";
      tag = finalAttrs.version;
      hash = "sha256-wpB/Pp/Z7vmT7OZdaFG8bEQOhA5s65bEEd4fu/1mWd8=";
    };

    patches = [
      ./patches/cc.patch
      ./patches/date.patch
      ./patches/emmetio-css-parser.patch
      ./patches/git-config.patch
      ./patches/node-gyp.patch
      ./patches/npm-install.patch
    ];

    npmDeps = stdenvNoCC.mkDerivation {
      name = "code-oss-${finalAttrs.version}-npm-deps";
      inherit (finalAttrs) src patches;

      nativeBuildInputs = [ prefetch-npm-deps ];

      buildPhase = ''
        FORCE_EMPTY_CACHE=true find . -name package-lock.json -exec sh -c 'echo prefetch-npm-deps {} \$out && prefetch-npm-deps {} $out' \;
        rm $out/package-lock.json
      '';

      outputHashMode = "recursive";
      outputHash = "sha256-h7zhJdE3IjW/Xj9ajFLW5TjvdBByRjH1/+sviE+YFyA=";
    };
    nativeBuildInputs = [
      writableTmpDirAsHomeHook
      nodejs
      nodejs.python
      which
      jq
      pkg-config
      krb5
      node-gyp
      (writeShellScriptBin "npm-install-script" ''
        source $stdenv/setup
        npm ci --ignore-scripts
        patchShebangs node_modules
        npm rebuild
        patchShebangs node_modules
      '')
    ]
    ++ lib.optionals hostPlatform.isDarwin [
      cctools.libtool
      xcbuild
      clang_19 # clang_20 breaks @vscode/spdlog
    ];
    buildInputs = lib.optionals hostPlatform.isLinux [
      libsecret
      xorg.libX11
      xorg.libxkbfile
    ];
    env = {
      BUILD_DATE = commitInfo.committer.date;
      BUILD_SOURCEVERSION = commitInfo.sha;
      npm_install_command = "npm-install-script";
      PLAYWRIGHT_SKIP_BROWSER_DOWNLOAD = "true";
      ELECTRON_SKIP_BINARY_DOWNLOAD = "true";
    };
    buildPhase = ''
      runHook preBuild

      cp -r "$npmDeps" "$TMPDIR/cache"
      chmod -R 700 "$TMPDIR/cache"
      cachePath="$TMPDIR/cache"
      export npm_config_cache="$cachePath"
      export npm_config_offline="true"
      export npm_config_progress="false"

      mkdir -p "${cache-dir}/node-gyp/${electron.version}"
      echo 11 > "${cache-dir}/node-gyp/${electron.version}/installVersion"
      ln -s "${electron.headers}/include" "${cache-dir}/node-gyp/${electron.version}/include"

      mkdir -p "${cache-dir}/node-gyp/${nodejs.version}"
      echo 11 > "${cache-dir}/node-gyp/${nodejs.version}/installVersion"
      ln -s "${nodejs}/include" "${cache-dir}/node-gyp/${nodejs.version}/include"

      substituteInPlace remote/.npmrc \
        --replace-fail "$(cat .nvmrc)" "${nodejs.version}"
      substituteInPlace .npmrc \
        --replace-fail "$(jq -r '.packages["node_modules/electron"].version' package-lock.json)" "${electron.version}"

      mkdir -p ${cache-dir}/electron/$(printf 'https://github.com/electron/electron/releases/download/v${electron.version}' | sha256sum | cut -f1 -d' ')/
      ln -s ${electron-dist-zip} ${cache-dir}/electron/$(printf 'https://github.com/electron/electron/releases/download/v${electron.version}' | sha256sum | cut -f1 -d' ')/electron-v${electron.version}-${platform}-${arch}.zip

      ${ripgrep-scripts}

      ln -s ${vscode-extensions.ms-vscode.js-debug-companion.src} ./ms-vscode.js-debug-companion.vsix
      ln -s ${vscode-extensions.ms-vscode.js-debug.src} ./ms-vscode.js-debug.vsix
      ln -s ${vscode-extensions.ms-vscode.vscode-js-profile-table.src} ./ms-vscode.vscode-js-profile-table.vsix

      jq \
        --arg js_debug_companion_vsix_sha "$(sha256sum ./ms-vscode.js-debug-companion.vsix | cut -d' ' -f1)" \
        --arg js_debug_vsix_sha "$(sha256sum ./ms-vscode.js-debug.vsix | cut -d' ' -f1)" \
        --arg vscode_js_profile_table_vsix_sha "$(sha256sum ./ms-vscode.vscode-js-profile-table.vsix | cut -d' ' -f1)" \
        '.builtInExtensions |=
          map(if .name == "ms-vscode.js-debug-companion"      then del(.repo) | .vsix = "./\(.name).vsix" | .sha256 = $js_debug_companion_vsix_sha
            elif .name == "ms-vscode.js-debug"                then del(.repo) | .vsix = "./\(.name).vsix" | .sha256 = $js_debug_vsix_sha
            elif .name == "ms-vscode.vscode-js-profile-table" then del(.repo) | .vsix = "./\(.name).vsix" | .sha256 = $vscode_js_profile_table_vsix_sha
            else . end)' product.json > product.json.tmp && mv product.json.tmp product.json

      substituteInPlace build/lib/electron.ts --replace-fail 'validateChecksum: true' 'validateChecksum: false'
      substituteInPlace build/lib/electron.js --replace-fail 'validateChecksum: true' 'validateChecksum: false'
      substituteInPlace src/vs/platform/dialogs/electron-browser/dialog.ts \
        --replace-fail "isLinuxSnap ? ' snap'" "isLinuxSnap === isLinuxSnap ? ' nix'"

      npm-install-script

      substituteInPlace node_modules/@vscode/gulp-electron/src/download.js \
        --replace-fail 'let downloadOpts = {' 'let downloadOpts = { unsafelyDisableChecksums: true,'

      node --run gulp -- vscode-${platform}-${arch}
    ''
    + lib.optionalString hostPlatform.isDarwin ''
      mv "../VSCode-${platform}-${arch}/Code - OSS.app" $out
    ''
    + lib.optionalString hostPlatform.isLinux ''
      mv "../VSCode-${platform}-${arch}" $out
    ''
    + ''
      runHook postBuild
    '';
  });
in
vscode-generic {
  inherit commandLineArgs useVSCodeRipgrep;

  inherit (code-oss-build) version;
  pname = "code-oss";

  executableName = "code-oss";
  sourceExecutableName = if hostPlatform.isDarwin then "code" else "code-oss";
  longName = "Code - OSS";
  shortName = "code-oss";
  libraryName = "code-oss";

  src = code-oss-build;
  sourceRoot = "";

  dontFixup = hostPlatform.isDarwin;
  updateScript = ./update.sh;

  meta = {
    description = "Code editor developed by Microsoft";
    mainProgram = "code-oss";
    longDescription = ''
      Code editor developed by Microsoft. It includes support for debugging,
      embedded Git control, syntax highlighting, intelligent code completion,
      snippets, and code refactoring. It is also customizable, so users can
      change the editor's theme, keyboard shortcuts, and preferences
    '';
    homepage = "https://github.com/microsoft/vscode";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [
      xiaoxiangmoe
    ];
    sourceProvenance = with lib.sourceTypes; [ fromSource ];
  };
}
