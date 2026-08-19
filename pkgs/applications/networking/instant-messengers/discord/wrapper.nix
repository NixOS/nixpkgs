{
  # Package metadata
  pname,
  source,
  meta,
  binaryName,
  desktopName,
  self,
  branch,
  # Feature flags (cross-platform)
  withOpenASAR ? false,
  withVencord ? false,
  withEquicord ? false,
  withMoonlight ? false,
  # Disabling this would normally break Discord.
  # The intended use-case for this is when SKIP_HOST_UPDATE is enabled via other means,
  # for example if a settings.json is linked declaratively (e.g., with home-manager).
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

  pkgArgs = removeAttrs args [
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

  configDir =
    if isLinux then
      "\${DISCORD_USER_DATA_DIR-\${XDG_CONFIG_HOME:-$HOME/.config}}/${lib.toLower binaryName}"
    else
      let
        configDirName = lib.replaceStrings [ " " ] [ "" ] (lib.toLower binaryName);
      in
      "\${DISCORD_USER_DATA_DIR-$HOME/Library/Application Support}/${configDirName}";

  # Symlink native modules from the nix store into the user config dir
  # where Discord's JS moduleUpdater expects them.
  stageModules = writeShellScript "discord-stage-modules" ''
    store_modules="$1"
    modules_dir="${configDir}/${version}/modules"
    rm -rf "$modules_dir"
    mkdir -p "$modules_dir"
    for m in ${lib.concatStringsSep " " (lib.attrNames moduleSrcs)}; do
      ln -sn "$store_modules/$m" "$modules_dir/$m"
    done
    echo '${builtins.toJSON (lib.mapAttrs (_: mod: { installedVersion = mod; }) moduleVersions)}' \
      > "$modules_dir/installed.json"
  '';

  disableBreakingUpdates =
    runCommand "disable-breaking-updates.py"
      {
        pythonInterpreter = python3.interpreter;
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
            ;
        }
      );

  passthru = {
    # make it possible to run disableBreakingUpdates and stageModules standalone
    inherit disableBreakingUpdates stageModules;
    # Exposed so reviewers can inspect which distro modules are pinned
    inherit source moduleVersions;
    updateScript = ./update.py;

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
