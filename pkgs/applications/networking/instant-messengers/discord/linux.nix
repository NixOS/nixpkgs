{
  pname,
  source,
  meta,
  binaryName,
  desktopName,
  self,
  autoPatchelfHook,
  fetchurl,
  makeDesktopItem,
  lib,
  stdenv,
  wrapGAppsHook3,
  makeShellWrapper,
  alsa-lib,
  at-spi2-atk,
  at-spi2-core,
  atk,
  cairo,
  cups,
  dbus,
  expat,
  fontconfig,
  freetype,
  gdk-pixbuf,
  glib,
  gtk3,
  libcxx,
  libdrm,
  libglvnd,
  libnotify,
  libpulseaudio,
  libuuid,
  libva,
  libx11,
  libxscrnsaver,
  libxcomposite,
  libxcursor,
  libxdamage,
  libxext,
  libxfixes,
  libxi,
  libxrandr,
  libxrender,
  libxtst,
  libxcb,
  libxkbcommon,
  libxshmfence,
  libgbm,
  nspr,
  nss,
  pango,
  systemdLibs,
  libappindicator-gtk3,
  libdbusmenu,
  brotli,
  writeShellScript,
  pipewire,
  python3,
  runCommand,
  libunity,
  speechd-minimal,
  wayland,
  branch,
  withOpenASAR ? false,
  openasar,
  withVencord ? false,
  vencord,
  withEquicord ? false,
  equicord,
  withMoonlight ? false,
  moonlight,
  withTTS ? true,
  enableAutoscroll ? false,
  # Disabling this would normally break Discord.
  # The intended use-case for this is when SKIP_HOST_UPDATE is enabled via other means,
  # for example if a settings.json is linked declaratively (e.g., with home-manager).
  disableUpdates ? true,
  commandLineArgs ? "",
  krispSrc ? null,
  withKrisp ? withOpenASAR || withVencord || withEquicord || withMoonlight,
  unzip,
}:

let
  discordMods = [
    withVencord
    withEquicord
    withMoonlight
  ];
  enabledDiscordModsCount = builtins.length (lib.filter (x: x) discordMods);

  inherit (source) version;

  src = fetchurl { inherit (source.distro) url hash; };

  moduleSrcs = lib.mapAttrs (_: mod: fetchurl { inherit (mod) url hash; }) source.modules;

  moduleVersions = lib.mapAttrs (_: mod: mod.version) source.modules;

  stagedModuleSrcs =
    if krispSrc != null && withKrisp then
      lib.removeAttrs moduleSrcs [ "discord_krisp" ]
    else
      moduleSrcs;

  libPath = lib.makeLibraryPath (
    [
      libcxx
      systemdLibs
      libpulseaudio
      libdrm
      libgbm
      stdenv.cc.cc
      alsa-lib
      atk
      at-spi2-atk
      at-spi2-core
      cairo
      cups
      dbus
      expat
      fontconfig
      freetype
      gdk-pixbuf
      glib
      gtk3
      libglvnd
      libnotify
      libx11
      libxcomposite
      libunity
      libuuid
      libva
      libxcursor
      libxdamage
      libxext
      libxfixes
      libxi
      libxrandr
      libxrender
      libxtst
      nspr
      # nss is intentionally NOT in libPath: it would leak via LD_LIBRARY_PATH
      # to xdg-open and break Firefox children when versions diverge (#514859,
      # PR #186603)
      libxcb
      libxkbcommon
      pango
      pipewire
      libxscrnsaver
      libappindicator-gtk3
      libdbusmenu
      wayland
    ]
    ++ lib.optionals withTTS [ speechd-minimal ]
  );

  # Symlink native modules from the nix store into the user config dir
  # where Discord's JS moduleUpdater expects them.
  stageModules = writeShellScript "discord-stage-modules" ''
    store_modules="$1"
    modules_dir="''${XDG_CONFIG_HOME:-$HOME/.config}/${lib.toLower binaryName}/${version}/modules"

    mkdir -p "$modules_dir"
    for m in ${lib.concatStringsSep " " (lib.attrNames moduleVersions)}; do
      rm -f "$modules_dir/pending/$m"-*.zip 2>/dev/null || true
    done
    for m in ${lib.concatStringsSep " " (lib.attrNames stagedModuleSrcs)}; do
      dest="$modules_dir/$m"
      if [ -L "$dest" ]; then
        rm "$dest"
      elif [ -e "$dest" ]; then
        chmod -R u+w "$dest" 2>/dev/null || true
        rm -rf "$dest"
      fi
      ln -sfn "$store_modules/$m" "$dest"
    done
    cat > "$modules_dir/installed.json.tmp" <<'EOF'
    ${builtins.toJSON (lib.mapAttrs (_: mod: { installedVersion = mod; }) moduleVersions)}
    EOF
    mv "$modules_dir/installed.json.tmp" "$modules_dir/installed.json"
  '';

  disableBreakingUpdates =
    runCommand "disable-breaking-updates.py"
      {
        pythonInterpreter = "${python3.interpreter}";
        configDirName = lib.toLower binaryName;
        skipModuleUpdate = lib.boolToString withOpenASAR;
        meta.mainProgram = "disable-breaking-updates.py";
      }
      ''
        mkdir -p $out/bin
        cp ${./disable-breaking-updates.py} $out/bin/disable-breaking-updates.py
        substituteAllInPlace $out/bin/disable-breaking-updates.py
        chmod +x $out/bin/disable-breaking-updates.py
      '';

  deployKrispPython = python3.withPackages (ps: [ ps.watchdog ]);

  patchedKrisp = lib.optionalAttrs (krispSrc != null && withKrisp) (
    runCommand "discord-krisp-patched"
      {
        nativeBuildInputs = [
          brotli
          unzip
          (python3.withPackages (ps: [
            ps.lief
            ps.capstone
          ]))
        ];
      }
      ''
        mkdir -p "$out"
        brotli -d < ${krispSrc} | tar xf - --strip-components=1 -C "$out"
        python3 ${./patch-krisp.py} "$out/discord_krisp.node"
        python3 ${./patch-krisp-module.py} "$out" linux
      ''
  );
in
assert lib.assertMsg (
  enabledDiscordModsCount <= 1
) "discord: Only one of Vencord, Equicord or Moonlight can be enabled at the same time";
stdenv.mkDerivation (finalAttrs: {
  inherit
    pname
    version
    src
    meta
    ;

  nativeBuildInputs = [
    autoPatchelfHook
    cups
    libdrm
    libuuid
    libxdamage
    libx11
    libxscrnsaver
    libxtst
    libxcb
    libxshmfence
    wrapGAppsHook3
    makeShellWrapper
    brotli
    python3
  ];

  dontWrapGApps = true;

  buildInputs = [
    alsa-lib
    libgbm
    nspr
    nss
    # The distro layout ships prebuilt `.node` modules:
    # discord_dispatch is linked against openssl 1.1, discord_voice against libpulseaudio.
    # Ignore the missing dependency on insecure openssl_1_1: discord_dispatch is
    # effectively unused in practice.
    libpulseaudio
  ];

  strictDeps = true;

  dontUnpack = true;

  inherit libPath;

  autoPatchelfIgnoreMissingDeps = [
    "libssl.so.1.1"
    "libcrypto.so.1.1"
  ];

  installPhase = ''
    runHook preInstall

    mkdir -p $out/{bin,opt/${binaryName},share/icons/hicolor/256x256/apps}

    # The host distro is a brotli-compressed tar with all files under a `files/`
    # prefix (the channel binary, libffmpeg.so, resources/, etc). Module distros
    # follow the same format with module contents under `files/`
    brotli -d < $src | tar xf - --strip-components=1 -C $out/opt/${binaryName}
    chmod +x $out/opt/${binaryName}/${binaryName}

    # The module directory layout must match what Discord's node runtime
    # expects: modules/<name>/ (the moduleUpdater extracts zips into
    # path.join(moduleInstallPath, moduleName) see processUnzipQueue)
    ${lib.concatStringsSep "\n" (
      lib.mapAttrsToList (name: src: ''
        mkdir -p $out/opt/${binaryName}/modules/${name}
        brotli -d < ${src} | tar xf - --strip-components=1 -C $out/opt/${binaryName}/modules/${name}
      '') stagedModuleSrcs
    )}
    ${lib.optionalString (krispSrc != null && withKrisp) ''
      mkdir -p $out/opt/${binaryName}/modules/discord_krisp
      cp -R ${patchedKrisp}/. $out/opt/${binaryName}/modules/discord_krisp/
      chmod -R u+w $out/opt/${binaryName}/modules/discord_krisp
    ''}

    wrapProgramShell $out/opt/${binaryName}/${binaryName} \
        "''${gappsWrapperArgs[@]}" \
        --add-flags "\''${NIXOS_OZONE_WL:+\''${WAYLAND_DISPLAY:+--ozone-platform=wayland --enable-features=WaylandWindowDecorations --enable-wayland-ime=true}}" \
        ${lib.strings.optionalString withTTS ''
          --run 'if [[ "''${NIXOS_SPEECH:-default}" != "False" ]]; then NIXOS_SPEECH=True; else unset NIXOS_SPEECH; fi' \
          --add-flags "\''${NIXOS_SPEECH:+--enable-speech-dispatcher}" \
        ''} \
        ${lib.strings.optionalString enableAutoscroll "--add-flags \"--enable-blink-features=MiddleClickAutoscroll\""} \
        --prefix XDG_DATA_DIRS : "${gtk3}/share/gsettings-schemas/${gtk3.name}/" \
        --prefix LD_LIBRARY_PATH : ${finalAttrs.libPath}:$out/opt/${binaryName} \
        ${lib.strings.optionalString disableUpdates "--run ${lib.getExe disableBreakingUpdates}"} \
        --run "${stageModules} $out/opt/${binaryName}/modules" \
        ${
          lib.strings.optionalString (
            krispSrc != null && withKrisp
          ) ''--run "$out/bin/.discord-deploy-krisp"''
        } \
        --add-flags ${lib.escapeShellArg commandLineArgs}

    ln -s $out/opt/${binaryName}/${binaryName} $out/bin/
    # Without || true the install would fail on case-insensitive filesystems
    ln -s $out/opt/${binaryName}/${binaryName} $out/bin/${lib.strings.toLower binaryName} || true
    ${lib.optionalString (krispSrc != null && withKrisp) ''
      cp ${./deploy-krisp.py} "$out/bin/.discord-deploy-krisp"
      substituteInPlace "$out/bin/.discord-deploy-krisp" \
        --replace-fail '@pythonInterpreter@' '${deployKrispPython}/bin/python3' \
        --replace-fail '@krispPath@' "$out/opt/${binaryName}/modules/discord_krisp" \
        --replace-fail '@discordVersion@' '${version}' \
        --replace-fail '@configDirName@' '${lib.toLower binaryName}'
      chmod +x "$out/bin/.discord-deploy-krisp"
    ''}

    ln -s $out/opt/${binaryName}/discord.png $out/share/icons/hicolor/256x256/apps/${pname}.png

    ln -s "$desktopItem/share/applications" $out/share/

    runHook postInstall
  '';

  postInstall =
    lib.strings.optionalString (krispSrc != null && withKrisp) ''
      python3 ${./patch-voice-krisp.py} \
        "$out/opt/${binaryName}/modules/discord_voice/index.js" \
        "require('path').join(process.env.XDG_CONFIG_HOME || require('path').join(require('os').homedir(), '.config'), '${lib.toLower binaryName}', '${version}', 'modules', 'discord_krisp')" \
        "$out/opt/${binaryName}/resources/build_info.json" \
        "$out/opt/${binaryName}/modules"
    ''
    + lib.strings.optionalString withOpenASAR ''
      cp -f ${openasar} $out/opt/${binaryName}/resources/app.asar
    ''
    + lib.strings.optionalString withVencord ''
      mv $out/opt/${binaryName}/resources/app.asar $out/opt/${binaryName}/resources/_app.asar
      mkdir $out/opt/${binaryName}/resources/app.asar
      echo '{"name":"discord","main":"index.js"}' > $out/opt/${binaryName}/resources/app.asar/package.json
      echo 'require("${vencord}/patcher.js")' > $out/opt/${binaryName}/resources/app.asar/index.js
    ''
    + lib.strings.optionalString withEquicord ''
      mv $out/opt/${binaryName}/resources/app.asar $out/opt/${binaryName}/resources/_app.asar
      mkdir $out/opt/${binaryName}/resources/app.asar
      echo '{"name":"discord","main":"index.js"}' > $out/opt/${binaryName}/resources/app.asar/package.json
      echo 'require("${equicord}/desktop/patcher.js")' > $out/opt/${binaryName}/resources/app.asar/index.js
    ''
    + lib.strings.optionalString withMoonlight ''
      mv $out/opt/${binaryName}/resources/app.asar $out/opt/${binaryName}/resources/_app.asar
      mkdir $out/opt/${binaryName}/resources/app
      echo '{"name":"discord","main":"injector.js","private": true}' > $out/opt/${binaryName}/resources/app/package.json
      echo 'require("${moonlight}/injector.js").inject(require("path").join(__dirname, "../_app.asar"));' > $out/opt/${binaryName}/resources/app/injector.js
    '';

  desktopItem = makeDesktopItem {
    name = pname;
    exec = binaryName;
    icon = pname;
    inherit desktopName;
    genericName = meta.description;
    categories = [
      "Network"
      "InstantMessaging"
    ];
    mimeTypes = [ "x-scheme-handler/discord" ];
    startupWMClass = "discord";
  };

  passthru = {
    # make it possible to run disableBreakingUpdates standalone
    inherit disableBreakingUpdates;
    # Exposed so reviewers can inspect which distro modules are pinned
    inherit source moduleVersions;
    updateScript = ./update.py;

    tests = {
      withVencord = self.override {
        withVencord = true;
      };
      withEquicord = self.override {
        withEquicord = true;
      };
      withMoonlight = self.override {
        withMoonlight = true;
      };
      withOpenASAR = self.override {
        withOpenASAR = true;
      };
      withKrisp = self.override {
        withKrisp = true;
      };
    };
  }
  // lib.optionalAttrs (krispSrc != null && withKrisp) { inherit patchedKrisp; };
})
