{ stdenv, fetchFromGitHub, python, zip, makeWrapper, fetchurl, pkgconfig, jq
, makeDesktopItem, runtimeShell, writeScript
, nodejs, yarn, libsecret, xorg, ripgrep, electron
, productOverrides ? {}
}:

with stdenv.lib;

let
  productDefaultOverrides = {
    extensionsGallery =  {
      serviceUrl = "https://marketplace.visualstudio.com/_apis/public/gallery";
      cacheUrl = "https://vscode.blob.core.windows.net/gallery/index";
      itemUrl = "https://marketplace.visualstudio.com/items";
    };
    extensionAllowedProposedApi = [
      "ms-vscode.references-view"
      "ms-vsliveshare.vsliveshare"
      "ms-vsliveshare.cloudenv"
      "ms-vsliveshare.cloudenv-explorer"
      "ms-vsonline.vsonline"
      "GitHub.vscode-pull-request-github"
      "GitHub.vscode-pull-request-github-insiders"
      "Microsoft.vscode-nmake-tools"
      "atlassian.atlascode"
      "ms-vscode-remote.remote-containers"
      "ms-vscode-remote.remote-containers-nightly"
      "ms-vscode-remote.remote-ssh"
      "ms-vscode-remote.remote-ssh-nightly"
      "ms-vscode-remote.remote-ssh-edit"
      "ms-vscode-remote.remote-ssh-edit-nightly"
      "ms-vscode-remote.vscode-remote-extensionpack"
      "ms-vscode-remote.vscode-remote-extensionpack-nightly"
      "ms-vscode.azure-account"
      "ms-vscode.js-debug"
      "ms-vscode.js-debug-nightly"
    ];
  };

  productOverrides' = productDefaultOverrides // productOverrides;

  shortName = productOverrides.nameShort or "Code - OSS";
  longName = productOverrides.nameLong or "Code - OSS";
  executableName = productOverrides.applicationName or "code-oss";

  # to get hash values use nix-build -A vscode-oss.yarnPrefetchCache --argstr system <system>
  vscodePlatforms = rec {
    x86_64-linux = {
      name = "linux-x64";
      yarnCacheSha256 = "0fhcfm2n52bas7gc674z63aydz2nq54zvb9q090986x081hpjzc5";
    };
    aarch64-linux = {
      name = "linux-arm64";
      yarnCacheSha256 = "0l85nggc9sf7ag99g7ynx8kkhn5rcw9fc68iqsxzib5sw3r20phd";
    };
  };

  system = stdenv.hostPlatform.system;

  platform = vscodePlatforms.${system} or (throw "Unsupported platform: ${system}");

in stdenv.mkDerivation rec {
  pname = "vscode-oss";
  version = "1.44.2";

  src = fetchFromGitHub {
    owner = "microsoft";
    repo = "vscode";
    rev = version;
    sha256 = "z0XdyD3lpcL90uGFlHeWHEJnnXmYPfpeaU0e2xjJnGU=";
  };

  yarnCache = stdenv.mkDerivation {
    name = "${pname}-${version}-${system}-yarn-cache";
    inherit src;
    phases = ["unpackPhase" "buildPhase"];
    nativeBuildInputs = [ yarn ];
    buildPhase = ''
      export HOME=$PWD

      yarn config set yarn-offline-mirror $out

      find . -name "yarn.lock" \
        -execdir yarn install --frozen-lockfile --ignore-scripts --no-progress --non-interactive \;
    '';
    outputHashMode = "recursive";
    outputHashAlgo = "sha256";
    outputHash = platform.yarnCacheSha256;
  };

  productOverridesJSON = builtins.toFile "product-override.json" (builtins.toJSON productOverrides');

  nativeBuildInputs = [ nodejs yarn python pkgconfig zip makeWrapper jq ];
  buildInputs = [ libsecret xorg.libX11 xorg.libxkbfile ];

  BUILD_SOURCEVERSION = version;

  desktopItem = makeDesktopItem {
    name = executableName;
    desktopName = longName;
    comment = "Code Editing. Redefined.";
    genericName = "Text Editor";
    exec = executableName;
    icon = "code";
    startupNotify = "true";
    categories = "Utility;TextEditor;Development;IDE;";
    mimeType = "text/plain;inode/directory;";
    extraEntries = ''
      StartupWMClass=${shortName}
      Actions=new-empty-window;
      Keywords=vscode;

      [Desktop Action new-empty-window]
      Name=New Empty Window
      Exec=${executableName} --new-window %F
      Icon=code
    '';
  };

  urlHandlerDesktopItem = makeDesktopItem {
    name = executableName + "-url-handler";
    desktopName = longName + " - URL Handler";
    comment = "Code Editing. Redefined.";
    genericName = "Text Editor";
    exec = executableName + " --open-url %U";
    icon = "code";
    startupNotify = "true";
    categories = "Utility;TextEditor;Development;IDE;";
    mimeType = "x-scheme-handler/vscode;";
    extraEntries = ''
      NoDisplay=true
      Keywords=vscode;
    '';
  };

  # vscode is started using vscode cli. To start cli no parameters should be
  # passed, but to start vscode itself path to electron app needs to be passed.
  # That's why we need to detect whether we need to pass path to app electron
  # or not
  electronWrapper = writeScript "${pname}-electron-wrapper" ''
    #!${runtimeShell}

    export VSCODE_BIN="@out@/lib/vscode/${executableName}"

    if [ "$VSCODE_CLI" == "1" ]; then
      exec "${electron}/bin/electron" "@out@/lib/vscode/resources/app" "$@"
    fi

    exec "${electron}/bin/electron" "$@"
  '';

  patchPhase = ''
    DEFAULT_TRUE="'default': true"
    DEFAULT_FALSE="'default': false"
    TELEMETRY_ENABLE="'telemetry.enableTelemetry':"
    TELEMETRY_CRASH_REPORTER="'telemetry.enableCrashReporter':"

    replace () {
      sed -i -E "$1" $2
    }

    update_setting () {
      # go through lines of file, looking for block that contains setting
      local SETTING="$1"
      local LINE_NUM=0
      while read -r line; do
        local LINE_NUM=$(( $LINE_NUM + 1 ))
        if [[ $line == *"$SETTING"* ]]; then
          local IN_SETTING=1
        fi
        if [[ $line == *"$DEFAULT_TRUE"* && "$IN_SETTING" == "1" ]]; then
          local FOUND=1
          break
        fi
      done < $FILENAME

      if [[ "$FOUND" != "1" ]]; then
        echo "$DEFAULT_TRUE not found for setting $SETTING in file $FILENAME"
        return
      fi

      # construct line-aware replacement string
      local DEFAULT_TRUE_TO_FALSE="''${LINE_NUM}s/''${DEFAULT_TRUE}/''${DEFAULT_FALSE}/"

      replace "$DEFAULT_TRUE_TO_FALSE" $FILENAME
    }

    # disable telemetry by default
    update_setting "$TELEMETRY_ENABLE" src/vs/platform/telemetry/common/telemetryService.ts
    update_setting "$TELEMETRY_CRASH_REPORTER" src/vs/workbench/electron-browser/desktop.contribution.ts

    sed -i '/target/c\target "${electron.version}"' .yarnrc

    # remove all built-in extensions, as these are 3rd party extensions that gets
    # downloaded from vscode marketplace
    echo '[]' > build/builtInExtensions.json

    # fix postinstall to allow passing --offline to yarn install
    substituteInPlace build/npm/postinstall.js --replace '--ignore-optional' '--offline'

    # execPath for shell, so it points to code-oss and not to electron binary
    substituteInPlace src/vs/code/node/cli.ts --replace 'process.execPath' 'process.env.VSCODE_BIN || process.execPath'
  '';

  configurePhase = ''
    export HOME=$PWD

    jq -s '.[0] * .[1]' product.json ${productOverridesJSON} | tee .product.json
    mv .product.json product.json

    # set offline mirror to yarn cache we created in previous steps
    yarn --offline config set yarn-offline-mirror "${yarnCache}"

    # change runtime to electron, this is needed later when building native binaries
    npm config set runtime electron

    # set target electron version and path to electron headers tarball
    npm config set target ${electron.version}
    npm config set tarball ${electron.headers}
  '';

  buildPhase = ''
    # provide our own electron and ffmpeg archives, that contain only a dummy
    # wrapper that starts electron in vscode folder
    electron_archive="electron-v${electron.version}-${platform.name}.zip"
    ffmpeg_archive="ffmpeg-v${electron.version}-${platform.name}.zip"
    gulp_electron_dir="$TMPDIR/gulp-electron-cache/atom/electron"

    substituteAll ${electronWrapper} electron
    chmod +x electron
    zip "$electron_archive" electron

    mkdir -p "$gulp_electron_dir"
    cp "$electron_archive" "$gulp_electron_dir/$electron_archive"
    cp "$electron_archive" "$gulp_electron_dir/$ffmpeg_archive"

    # install without running scripts, for all required packages that needs patching
    for d in . remote build test/automation; do
      yarn install --cwd $d --frozen-lockfile --offline --no-progress --non-interactive --ignore-scripts
    done

    # put ripgrep binary into bin folder, so postinstall does not try to download it
    find -name vscode-ripgrep -type d \
      -execdir mkdir -p {}/bin \; \
      -execdir ln -s ${ripgrep}/bin/rg {}/bin/rg \;

    # patch shebangs of everything, also cached files, as otherwise postinstall
    # will not be able to find /usr/bin/env, as it does not exists in sandbox
    patchShebangs .

    # rebuild binaries, we use npm here, as yarn does not provider alternative
    npm rebuild --update-binary

    # run postinstall scripts, which eventually do yarn install on all additional requirements
    yarn postinstall --offline --frozen-lockfile

    # build vscode itself
    yarn gulp vscode-${platform.name}-min
  '';

  installPhase = ''
    mkdir -p $out/lib/vscode $out/bin
    cp -r ../VSCode-${platform.name}/* $out/lib/vscode

    substituteInPlace $out/lib/vscode/bin/${executableName} --replace '"$CLI" "$@"' '"$CLI" "--skip-getting-started" "$@"'

    ln -s $out/lib/vscode/bin/${executableName} $out/bin

    mkdir -p $out/share/applications
    ln -s $desktopItem/share/applications/${executableName}.desktop $out/share/applications/${executableName}.desktop
    ln -s $urlHandlerDesktopItem/share/applications/${executableName}-url-handler.desktop $out/share/applications/${executableName}-url-handler.desktop

    mkdir -p $out/share/pixmaps
    cp $out/lib/vscode/resources/app/resources/linux/code.png $out/share/pixmaps/code.png

    # Override the previously determined VSCODE_PATH with the one we know to be correct
    sed -i "/ELECTRON=/iVSCODE_PATH='$out/lib/vscode'" $out/bin/${executableName}
    grep -q "VSCODE_PATH='$out/lib/vscode'" $out/bin/${executableName} # check if sed succeeded
  '';

  passthru = {
    inherit executableName;
    prefetchYarnCache = overrideDerivation yarnCache (d: {
      outputHash = "0000000000000000000000000000000000000000000000000000000000000000";
    });
  };

  meta = {
    description = ''
      Open source source code editor developed by Microsoft for Windows,
      Linux and macOS
    '';
    longDescription = ''
      Open source source code editor developed by Microsoft for Windows,
      Linux and macOS. It includes support for debugging, embedded Git
      control, syntax highlighting, intelligent code completion, snippets,
      and code refactoring. It is also customizable, so users can change the
      editor's theme, keyboard shortcuts, and preferences
    '';
    homepage = "https://code.visualstudio.com/";
    license = licenses.mit;
    maintainers = with maintainers; [ offline ];

    # all platforms that vscode and electron support
    platforms = intersectLists (attrNames vscodePlatforms) electron.meta.platforms;
  };
}
