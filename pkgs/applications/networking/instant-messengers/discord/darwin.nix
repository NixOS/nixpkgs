{
  pname,
  source,
  meta,
  stdenv,
  binaryName,
  desktopName,
  self,
  lib,
  fetchurl,
  makeWrapper,
  writeScript,
  writeShellScript,
  brotli,
  python3,
  runCommand,
  branch,
  withOpenASAR ? false,
  openasar,
  withVencord ? false,
  vencord,
  withEquicord ? false,
  equicord,
  withMoonlight ? false,
  moonlight,
  commandLineArgs ? "",
  krispSrc ? null,
  withKrisp ? withOpenASAR || withVencord || withEquicord || withMoonlight,
  unzip,
  darwin,
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

  configDirName = lib.replaceStrings [ " " ] [ "" ] (lib.toLower binaryName);

  fixDistroSymlinks = writeScript "discord-fix-distro-symlinks.py" ''
    #!${python3.interpreter}
    import pathlib
    import sys
    import tarfile

    with tarfile.open(sys.argv[1]) as tar:
        for member in tar:
            if not member.issym():
                continue
            parts = pathlib.PurePosixPath(member.name).parts[1:]
            if not parts:
                continue
            path = pathlib.Path(sys.argv[2], *parts)
            path.unlink(missing_ok=True)
            path.symlink_to(member.linkname)
  '';

  stageModules = writeShellScript "discord-stage-modules" ''
    store_modules="$1"
    darwin_home="$(${python3.interpreter} -c 'import os, pwd; print(pwd.getpwuid(os.getuid()).pw_dir)')"
    modules_dir="$darwin_home/Library/Application Support/${configDirName}/${version}/modules"

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
        python3 ${./patch-krisp-module.py} "$out" darwin
        source ${darwin.signingUtils}
        sign "$out/discord_krisp.node"
      ''
  );

  deployKrisp = lib.optionalAttrs (krispSrc != null && withKrisp) (
    runCommand "deploy-krisp.py"
      {
        pythonInterpreter = "${python3.withPackages (ps: [ ps.watchdog ])}/bin/python3";
        krispPath = "${patchedKrisp}";
        discordVersion = version;
        configDirName = lib.toLower binaryName;
        meta.mainProgram = "deploy-krisp.py";
      }
      ''
        mkdir -p "$out/bin"
        cp ${./deploy-krisp.py} "$out/bin/deploy-krisp.py"
        substituteAllInPlace "$out/bin/deploy-krisp.py"
        chmod +x "$out/bin/deploy-krisp.py"
      ''
  );
in
assert lib.assertMsg (
  enabledDiscordModsCount <= 1
) "discord: Only one of Vencord, Equicord or Moonlight can be enabled at the same time";
stdenv.mkDerivation {
  inherit
    pname
    version
    src
    meta
    ;

  nativeBuildInputs = [
    brotli
    makeWrapper
    python3
  ];

  sourceRoot = ".";

  dontUnpack = true;

  installPhase = ''
    runHook preInstall

    mkdir -p $out/Applications

    extractDistro() {
      local src="$1"
      local dest="$2"
      local tarball
      tarball=$(mktemp)
      brotli -d < "$src" > "$tarball"
      tar xf "$tarball" --strip-components=1 -C "$dest"

      # Discord's distro tarballs store symlinks with mode 000, which makes
      # them unreadable on Darwin. Recreate them with normal permissions.
      ${fixDistroSymlinks} "$tarball" "$dest"
      rm "$tarball"
    }

    extractDistro "$src" "$out/Applications"

    ${lib.concatStringsSep "\n" (
      lib.mapAttrsToList (name: src: ''
        mkdir -p "$out/Applications/${desktopName}.app/Contents/Resources/modules/${name}"
        extractDistro ${src} "$out/Applications/${desktopName}.app/Contents/Resources/modules/${name}"
      '') stagedModuleSrcs
    )}
    ${lib.optionalString (krispSrc != null && withKrisp) ''
      mkdir -p "$out/Applications/${desktopName}.app/Contents/Resources/modules/discord_krisp"
      cp -R ${patchedKrisp}/. "$out/Applications/${desktopName}.app/Contents/Resources/modules/discord_krisp/"
      chmod -R u+w "$out/Applications/${desktopName}.app/Contents/Resources/modules/discord_krisp"
    ''}

    # wrap executable to $out/bin
    mkdir -p $out/bin
    makeWrapper "$out/Applications/${desktopName}.app/Contents/MacOS/${binaryName}" "$out/bin/${binaryName}" \
      --run ${lib.getExe disableBreakingUpdates} \
      --run "${stageModules} \"$out/Applications/${desktopName}.app/Contents/Resources/modules\"" \
      ${lib.strings.optionalString (krispSrc != null && withKrisp) "--run ${lib.getExe deployKrisp}"} \
      --add-flags ${lib.escapeShellArg commandLineArgs}

    runHook postInstall
  '';

  postInstall =
    lib.strings.optionalString (krispSrc != null && withKrisp) ''
      python3 ${./patch-voice-krisp.py} \
        "$out/Applications/${desktopName}.app/Contents/Resources/modules/discord_voice/index.js" \
        "require('path').join(require('os').userInfo().homedir, 'Library', 'Application Support', '${configDirName}', '${version}', 'modules', 'discord_krisp')"
    ''
    + lib.strings.optionalString withOpenASAR ''
      cp -f ${openasar} "$out/Applications/${desktopName}.app/Contents/Resources/app.asar"
    ''
    + lib.strings.optionalString withVencord ''
      mv "$out/Applications/${desktopName}.app/Contents/Resources/app.asar" "$out/Applications/${desktopName}.app/Contents/Resources/_app.asar"
      mkdir "$out/Applications/${desktopName}.app/Contents/Resources/app.asar"
      echo '{"name":"discord","main":"index.js"}' > "$out/Applications/${desktopName}.app/Contents/Resources/app.asar/package.json"
      echo 'require("${vencord}/patcher.js")' > "$out/Applications/${desktopName}.app/Contents/Resources/app.asar/index.js"
    ''
    + lib.strings.optionalString withEquicord ''
      mv "$out/Applications/${desktopName}.app/Contents/Resources/app.asar" "$out/Applications/${desktopName}.app/Contents/Resources/_app.asar"
      mkdir "$out/Applications/${desktopName}.app/Contents/Resources/app.asar"
      echo '{"name":"discord","main":"index.js"}' > "$out/Applications/${desktopName}.app/Contents/Resources/app.asar/package.json"
      echo 'require("${equicord}/desktop/patcher.js")' > "$out/Applications/${desktopName}.app/Contents/Resources/app.asar/index.js"
    ''
    + lib.strings.optionalString withMoonlight ''
      mv "$out/Applications/${desktopName}.app/Contents/Resources/app.asar" "$out/Applications/${desktopName}.app/Contents/Resources/_app.asar"
      mkdir "$out/Applications/${desktopName}.app/Contents/Resources/app.asar"
      echo '{"name":"discord","main":"injector.js","private": true}' > "$out/Applications/${desktopName}.app/Contents/Resources/app.asar/package.json"
      echo 'require("${moonlight}/injector.js").inject(require("path").join(__dirname, "../_app.asar"));' > "$out/Applications/${desktopName}.app/Contents/Resources/app.asar/injector.js"
    '';

  passthru = {
    # make it possible to run disableBreakingUpdates standalone
    inherit disableBreakingUpdates;
    inherit source;
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
}
