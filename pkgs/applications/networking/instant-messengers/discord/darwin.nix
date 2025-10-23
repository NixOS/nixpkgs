{
  pname,
  version,
  src,
  meta,
  stdenv,
  binaryName,
  desktopName,
  self,
  lib,
  undmg,
  makeWrapper,
  writeScript,
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
}:

let
  discordMods = [
    withVencord
    withEquicord
    withMoonlight
  ];
  enabledDiscordModsCount = builtins.length (lib.filter (x: x) discordMods);

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
stdenv.mkDerivation {
  inherit
    pname
    version
    src
    meta
    ;

  nativeBuildInputs = [
    undmg
    makeWrapper
  ];

  sourceRoot = ".";

  installPhase = ''
    runHook preInstall

    mkdir -p $out/Applications
    cp -r "${desktopName}.app" $out/Applications

    # wrap executable to $out/bin
    mkdir -p $out/bin
    makeWrapper "$out/Applications/${desktopName}.app/Contents/MacOS/${binaryName}" "$out/bin/${binaryName}" \
      --run ${lib.getExe disableBreakingUpdates} \
      --add-flags ${lib.escapeShellArg commandLineArgs}

    runHook postInstall
  '';

  postInstall =
    lib.strings.optionalString withOpenASAR ''
      cp -f ${openasar} $out/Applications/${desktopName}.app/Contents/Resources/app.asar
    ''
    + lib.strings.optionalString withVencord ''
      mv $out/Applications/${desktopName}.app/Contents/Resources/app.asar $out/Applications/${desktopName}.app/Contents/Resources/_app.asar
      mkdir $out/Applications/${desktopName}.app/Contents/Resources/app.asar
      echo '{"name":"discord","main":"index.js"}' > $out/Applications/${desktopName}.app/Contents/Resources/app.asar/package.json
      echo 'require("${vencord}/patcher.js")' > $out/Applications/${desktopName}.app/Contents/Resources/app.asar/index.js
    ''
    + lib.strings.optionalString withEquicord ''
      mv $out/Applications/${desktopName}.app/Contents/Resources/app.asar $out/Applications/${desktopName}.app/Contents/Resources/_app.asar
      mkdir $out/Applications/${desktopName}.app/Contents/Resources/app.asar
      echo '{"name":"discord","main":"index.js"}' > $out/Applications/${desktopName}.app/Contents/Resources/app.asar/package.json
      echo 'require("${equicord}/patcher.js")' > $out/Applications/${desktopName}.app/Contents/Resources/app.asar/index.js
    ''
    + lib.strings.optionalString withMoonlight ''
      mv $out/Applications/${desktopName}.app/Contents/Resources/app.asar $out/Applications/${desktopName}.app/Contents/Resources/_app.asar
      mkdir $out/Applications/${desktopName}.app/Contents/Resources/app.asar
      echo '{"name":"discord","main":"injector.js","private": true}' > $out/Applications/${desktopName}.app/Contents/Resources/app.asar/package.json
      echo 'require("${moonlight}/injector.js").inject(require("path").join(__dirname, "../_app.asar"));' > $out/Applications/${desktopName}.app/Contents/Resources/app.asar/injector.js
    '';

  passthru = {
    # make it possible to run disableBreakingUpdates standalone
    inherit disableBreakingUpdates;
    updateScript = writeScript "discord-update-script" ''
      #!/usr/bin/env nix-shell
      #!nix-shell -i bash -p curl gnugrep common-updater-scripts
      set -x
      set -eou pipefail;
      url=$(curl -sI -o /dev/null -w '%header{location}' "https://discord.com/api/download/${branch}?platform=osx&format=dmg")
      version=$(echo $url | grep -oP '/\K(\d+\.){2}\d+')
      update-source-version ${
        lib.optionalString (!stdenv.buildPlatform.isDarwin) "pkgsCross.aarch64-darwin."
      }${pname} "$version" --file=./pkgs/applications/networking/instant-messengers/discord/default.nix --version-key=${branch}
    '';

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
}
