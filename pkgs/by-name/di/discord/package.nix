{
  # Package metadata
  pname ? "discord",
  source ? (callPackage ./metadata.nix { }).${pname}.source,
  # Feature flags (cross-platform)
  withOpenASAR ? false,
  withVencord ? false,
  withEquicord ? false,
  withMoonlight ? false,
  # Disabling this would normally break Discord.
  # The intended use-case is when SKIP_HOST_UPDATE and SKIP_MODULE_UPDATE are
  # enabled via other means, such as a declaratively linked settings.json
  disableUpdates ? true,
  # Feature flags (Linux exclusive)
  withTTS ? true,
  enableAutoscroll ? false,
  # If true, the resulting derivation will be made using buildFHSEnv to wrap the inner
  # Discord package. If false, the unwrappedDiscord package will be returned directly.
  # Setting this value to false is not recommended, as Krisp will refuse to load due
  # to the Discord binary being patched.
  useFHSEnv ? stdenv.hostPlatform.isLinux,
  # Package arguments
  commandLineArgs ? "",
  unwrappedDiscord ? null,
  # Miscellaneous
  lib,
  stdenv,
  buildFHSEnv,
  writeShellScript,
  runCommand,
  callPackage,
  fetchurl,
  python3,
  # Discord mods
  openasar,
  vencord,
  equicord,
  moonlight,
}@args:

let
  inherit (stdenv.hostPlatform) isLinux;

  metadata = (callPackage ./metadata.nix { }).${pname};
  inherit (metadata)
    meta
    binaryName
    desktopName
    self
    branch
    ;

  pkgArgs = removeAttrs (args // metadata // { inherit source; }) [
    "branch"
    "self"
    "unwrappedDiscord"
    "buildFHSEnv"
    "writeShellScript"
    "runCommand"
    "callPackage"
    "python3"
  ];

  discordMods = [
    withVencord
    withEquicord
    withMoonlight
  ];
  enabledDiscordModsCount = builtins.length (lib.filter (x: x) discordMods);

  inherit (source) version;

  moduleSrcs = lib.mapAttrs (_: mod: fetchurl { inherit (mod) url hash; }) source.modules;

  moduleVersions = lib.mapAttrs (_: mod: mod.version) source.modules;

  moduleManifest = builtins.toJSON (
    lib.mapAttrs (_: mod: { installedVersion = mod; }) moduleVersions
  );

  configDir =
    if isLinux then
      "\${DISCORD_USER_DATA_DIR-\${XDG_CONFIG_HOME:-$HOME/.config}}/${lib.toLower binaryName}"
    else
      let
        configDirName = lib.replaceStrings [ " " ] [ "" ] (lib.toLower binaryName);
      in
      "\${DISCORD_USER_DATA_DIR-$HOME/Library/Application Support}/${configDirName}";

  # Link the whole directory so Discord's native module boundary check sees
  # the same real path for the module root and the modules it contains
  # See https://github.com/NixOS/nixpkgs/issues/580512
  #
  # On Linux the tree is staged as a writable copy instead of a symlink:
  # discord_voice bundles MediaPipe's selfie-segmentation `.tflite` models,
  # which the native voice engine opens read-write (O_RDWR). In the read-only
  # store that open fails with EACCES, so background blur / virtual
  # backgrounds render a black camera image. The whole tree is copied (not
  # just discord_voice) to keep a single real module root for the boundary
  # check above. The copy is reused until the store path changes.
  stageModules = writeShellScript "discord-stage-modules" (
    ''
      store_modules="$1"
      modules_dir="${configDir}/${version}/modules"
    ''
    + (
      if isLinux then
        ''
          stamp="$modules_dir.nix-store-path"
          if [ -d "$modules_dir" ] && [ ! -L "$modules_dir" ] \
            && [ "$(cat "$stamp" 2>/dev/null)" = "$store_modules" ]; then
            exit 0
          fi
          rm -rf "$modules_dir" "$modules_dir.tmp" "$stamp"
          mkdir -p "$(dirname "$modules_dir")"
          cp -R "$store_modules" "$modules_dir.tmp"
          chmod -R u+w "$modules_dir.tmp"
          mv "$modules_dir.tmp" "$modules_dir"
          printf '%s\n' "$store_modules" > "$stamp"
        ''
      else
        ''
          rm -rf "$modules_dir"
          mkdir -p "$(dirname "$modules_dir")"
          ln -s "$store_modules" "$modules_dir"
        ''
    )
  );

  disableBreakingUpdates =
    runCommand "disable-breaking-updates.py"
      {
        pythonInterpreter = python3.interpreter;
        configDirName = lib.toLower binaryName;
        meta.mainProgram = "disable-breaking-updates.py";
      }
      ''
        mkdir -p $out/bin
        cp ${./disable-breaking-updates.py} $out/bin/disable-breaking-updates.py
        substituteAllInPlace $out/bin/disable-breaking-updates.py
        chmod +x $out/bin/disable-breaking-updates.py
      '';

  # Remove arguments not supported by the Darwin package.
  platformPkgArgs =
    if isLinux then
      pkgArgs
    else
      removeAttrs pkgArgs [
        "withTTS"
        "enableAutoscroll"
        "useFHSEnv"
      ];
  finalUnwrapped =
    if unwrappedDiscord != null then
      unwrappedDiscord
    else
      callPackage (if isLinux then ./linux.nix else ./darwin.nix) (
        platformPkgArgs
        // {
          inherit
            pname
            passthru
            disableBreakingUpdates
            stageModules
            moduleSrcs
            moduleManifest
            ;
        }
      );

  passthru = {
    # make it possible to run disableBreakingUpdates and stageModules standalone
    inherit disableBreakingUpdates stageModules;
    # Exposed so reviewers can inspect which distro modules are pinned
    inherit source moduleVersions;
    updateScript = {
      command = ./update.py;
      supportedFeatures = [ "commit" ];
    };

    unwrappedDiscord = finalUnwrapped;

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
      noFHSEnv = self.override {
        useFHSEnv = false;
      };
    };
  };

in
assert lib.assertMsg (
  enabledDiscordModsCount <= 1
) "discord: Only one of Vencord, Equicord, or Moonlight can be enabled at the same time";
if useFHSEnv then
  assert lib.assertMsg isLinux "discord: buildFHSEnv is only available on Linux";
  buildFHSEnv {
    inherit
      source
      pname
      meta
      version
      passthru
      stageModules
      disableBreakingUpdates
      ;

    inherit (finalUnwrapped.passthru) targetPkgs;

    src = fetchurl { inherit (source.distro) url hash; };

    extraInstallCommands = ''
      ln -s ${finalUnwrapped}/share $out/share

      # Without || true the install would fail on case-insensitive filesystems
      ln -s $out/bin/${binaryName} $out/bin/${lib.strings.toLower binaryName} || true
    '';

    executableName = binaryName;

    runScript = "${finalUnwrapped}/bin/${binaryName}";
  }
else
  finalUnwrapped.overrideAttrs (oldAttrs: {
    passthru = (oldAttrs.passthru or { }) // passthru;
  })
