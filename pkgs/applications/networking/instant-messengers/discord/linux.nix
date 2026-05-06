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
  openssl_1_1,
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
}:

let
  discordMods = [
    withVencord
    withEquicord
    withMoonlight
  ];
  enabledDiscordModsCount = builtins.length (lib.filter (x: x) discordMods);

  # Starting with discord-development 0.0.235, the linux tarball ships only a
  # small `updater_bootstrap` ELF that downloads the real app at first launch
  #
  # That binary always fetches the latest version from Discord's CDN with no way
  # to pin, making the build impure and the nix version a lie
  #
  # Instead we fetch the app directly from the distributions API at build time:
  # https://updates.discord.com/distributions/app/manifests/latest?channel=...
  # The host + module distros are brotli-compressed tars on Discord's CDN at
  # predictable URLs with SHA256 hashes in the manifest
  isDistro = source.kind == "distro";

  inherit (source) version;

  src =
    if isDistro then
      fetchurl { inherit (source.distro) url hash; }
    else
      fetchurl { inherit (source) url hash; };

  moduleSrcs = lib.optionalAttrs isDistro (
    lib.mapAttrs (_: mod: fetchurl { inherit (mod) url hash; }) source.modules
  );

  moduleVersions = lib.optionalAttrs isDistro (lib.mapAttrs (_: mod: mod.version) source.modules);

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
    if [ ! -f "$modules_dir/installed.json" ]; then
      mkdir -p "$modules_dir"
      for m in ${lib.concatStringsSep " " (lib.attrNames moduleSrcs)}; do
        ln -sfn "$store_modules/$m" "$modules_dir/$m"
      done
      echo '${builtins.toJSON (lib.mapAttrs (_: mod: { installedVersion = mod; }) moduleVersions)}' \
        > "$modules_dir/installed.json"
    fi
  '';

  disableBreakingUpdates =
    runCommand "disable-breaking-updates.py"
      {
        pythonInterpreter = "${python3.interpreter}";
        configDirName = lib.toLower binaryName;
        meta.mainProgram = "disable-breaking-updates.py";
      }
      ''
        mkdir -p $out/bin
        cp ${./disable-breaking-updates.py} $out/bin/disable-breaking-updates.py
        substituteAllInPlace $out/bin/disable-breaking-updates.py
        chmod +x $out/bin/disable-breaking-updates.py
      '';
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
  ]
  ++ lib.optionals isDistro [ brotli ];

  dontWrapGApps = true;

  buildInputs = [
    alsa-lib
    libgbm
    nspr
    nss
  ]
  # The new distro layout ships prebuilt `.node` modules:
  # discord_dispatch is linked against openssl 1.1, discord_voice against libpulseaudio
  ++ lib.optionals isDistro [
    openssl_1_1
    libpulseaudio
  ];

  strictDeps = true;

  dontUnpack = isDistro;

  inherit libPath;

  installPhase = ''
    runHook preInstall

    mkdir -p $out/{bin,opt/${binaryName},share/icons/hicolor/256x256/apps}
  ''
  + (
    if isDistro then
      ''
        # Distro layout (currently discord-ptb, discord-canary and discord-development):
        #
        # The host distro is a brotli-compressed tar with all files under a `files/`
        # prefix (the channel binary, libffmpeg.so, resources/, etc). Module distros
        # follow the same format with module contents under `files/`
        #
        # The module directory layout must match what Discord's node runtime
        # expects: modules/<name>/ (the moduleUpdater extracts zips into
        # path.join(moduleInstallPath, moduleName) see processUnzipQueue)

        brotli -d < $src | tar xf - --strip-components=1 -C $out/opt/${binaryName}
        chmod +x $out/opt/${binaryName}/${binaryName}

        # Extract native modules
        ${lib.concatStringsSep "\n" (
          lib.mapAttrsToList (name: src: ''
            mkdir -p $out/opt/${binaryName}/modules/${name}
            brotli -d < ${src} | tar xf - --strip-components=1 -C $out/opt/${binaryName}/modules/${name}
          '') moduleSrcs
        )}

      ''
    else
      ''
        # Tarball layout (stable): the tarball unpacks into a
        # directory containing the channel binary directly
        mv * $out/opt/${binaryName}
        chmod +x $out/opt/${binaryName}/${binaryName}
      ''
  )
  + ''

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
        ${lib.strings.optionalString isDistro ''--run "${stageModules} $out/opt/${binaryName}/modules"''} \
        --add-flags ${lib.escapeShellArg commandLineArgs}

    ln -s $out/opt/${binaryName}/${binaryName} $out/bin/
    # Without || true the install would fail on case-insensitive filesystems
    ln -s $out/opt/${binaryName}/${binaryName} $out/bin/${lib.strings.toLower binaryName} || true

    ln -s $out/opt/${binaryName}/discord.png $out/share/icons/hicolor/256x256/apps/${pname}.png

    ln -s "$desktopItem/share/applications" $out/share/

    runHook postInstall
  '';

  postInstall =
    lib.strings.optionalString withOpenASAR ''
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
    };
  };
})
