{ pname, version, src, meta, stdenv, binaryName, desktopName, lib, undmg, makeWrapper, writeScript
, branch
, withOpenASAR ? false, openasar
, withVencord ? false, vencord }:

stdenv.mkDerivation {
  inherit pname version src meta;

  nativeBuildInputs = [ undmg makeWrapper ];

  sourceRoot = ".";

  installPhase = ''
    runHook preInstall

    mkdir -p $out/Applications
    cp -r "${desktopName}.app" $out/Applications

    # wrap executable to $out/bin
    mkdir -p $out/bin
    makeWrapper "$out/Applications/${desktopName}.app/Contents/MacOS/${binaryName}" "$out/bin/${binaryName}"

    runHook postInstall
  '';

  postInstall = lib.strings.optionalString withOpenASAR ''
    cp -f ${openasar} $out/Applications/${desktopName}.app/Contents/Resources/app.asar
  '' + lib.strings.optionalString withVencord ''
    mv $out/Applications/${desktopName}.app/Contents/Resources/app.asar $out/Applications/${desktopName}.app/Contents/Resources/_app.asar
    mkdir $out/Applications/${desktopName}.app/Contents/Resources/app.asar
    echo '{"name":"discord","main":"index.js"}' > $out/Applications/${desktopName}.app/Contents/Resources/app.asar/package.json
    echo 'require("${vencord}/patcher.js")' > $out/Applications/${desktopName}.app/Contents/Resources/app.asar/index.js
  '';

  passthru = {
    updateScript = writeScript "discord-update-script" ''
      #!/usr/bin/env nix-shell
      #!nix-shell -i bash -p curl gnugrep common-updater-scripts
      set -x
      set -eou pipefail;
      url=$(curl -sI "https://discordapp.com/api/download/${
        builtins.replaceStrings [ "discord-" "discord" ] [ "" "stable" ] pname
      }?platform=osx&format=dmg" | grep -oP 'location: \K\S+')
      version=''${url##https://dl*.discordapp.net/apps/osx/}
      version=''${version%%/*.dmg}
      update-source-version ${lib.optionalString (!stdenv.buildPlatform.isDarwin) "pkgsCross.aarch64-darwin."}${pname} "$version" --file=./pkgs/applications/networking/instant-messengers/discord/default.nix --version-key=${branch}
    '';
  };
}
