{
  lib,
  stdenvNoCC,
  fetchurl,
  fetchzip,
  undmg,
  autoPatchelfHook,
  makeDesktopItem,
  copyDesktopItems,
  makeWrapper,
  unzip,
  jq,
  runtimeShell,
  buildFHSEnv,
  patchelfUnstable,
}:

# not used anywhere, but otherwise nixpkgs-update bot won't open a PR
# x86_64-darwin-release-id = "52";
# x86_64-linux-release-id = "52";

let
  pname = "foldit";
  meta = {
    description = "Revolutionary crowdsourcing computer game";
    homepage = "https://fold.it";
    changelog = "https://fold.it/releases";
    downloadPage = "https://fold.it/play";
    license = lib.licenses.unfree;
    maintainers = with lib.maintainers; [ ulysseszhan ];
    platforms = [
      "x86_64-linux"
      "x86_64-darwin"
    ];
    sourceProvenance = with lib.sourceTypes; [ binaryNativeCode ];
    mainProgram = "Foldit";
  };

  stdenv = stdenvNoCC;

  hotUpdates = (lib.importJSON ./hot-updates.json).${stdenv.hostPlatform.system} or { };
  versions = hotUpdates.versions or (throw "Unsupported system ${stdenv.hostPlatform.system}");
  version = builtins.toString versions.release_id or 0;
  components = versions.components;
  componentHashes = hotUpdates.hashes or (throw "Unsupported system ${stdenv.hostPlatform.system}");
  updateSrc = builtins.mapAttrs (
    name: value:
    fetchurl {
      url = value.download;
      hash = componentHashes.${name};
    }
  ) components;

  buildCommands = ''
    jq '.["${stdenv.hostPlatform.system}"].versions' ${./hot-updates.json} > versions.json
    ${lib.concatStrings (
      lib.mapAttrsToList (componentName: componentSrc: ''
        component_version=${components.${componentName}.version}
        echo -n $component_version > version-${componentName}.txt
        component_dir=cmp-${componentName}-$component_version
        rm -r cmp-${componentName}-*
        mkdir -p $component_dir
        unzip -d $component_dir ${componentSrc}
      '') updateSrc
    )}
  '';

  wrapper = buildFHSEnv {
    pname = "foldit-wrapper";
    inherit version;

    targetPkgs =
      ps: with ps; [
        libGL
        libGLU
        xclip
        freeglut
        libx11
        libpulseaudio
      ];
  };

  linuxArgs = {
    src = fetchzip {
      url = "https://web.archive.org/web/20260308095039/https://files.ipd.uw.edu/pub/foldit/Foldit-linux_x64.tar.gz";
      hash = "sha256-xMbPevtnrBZx9hT8/uVSpMvUwNfcWdHqZ9v5FJLMR3g=";
    };

    nativeBuildInputs = [
      copyDesktopItems
      makeWrapper
      unzip
      jq
      patchelfUnstable
    ];

    buildPhase = ''
      runHook preBuild

      ${buildCommands}

      runHook postBuild
    '';

    installPhase =
      let
        phome = "${placeholder "out"}/opt/Foldit";
      in
      ''
        runHook preInstall

        mkdir -p ${phome}
        cp -r * ${phome}

        mkdir -p $out/bin
        # Upstream refused to make it work without write access to its installation dir:
        # https://fold.it/forum/discussion/allow-tweaks-to-foldit-behavior-with-files-in-linux-to-meet-the-requirement-of-package-managers
        cat <<'EOF' > $out/bin/Foldit
        #!${runtimeShell}
        writableHome="''${XDG_DATA_DIR:-''$HOME/.local/share}/Foldit"
        mkdir -p "$writableHome"
        cd "$writableHome"
        if [ ! -f Foldit ] || [ "$(readlink -f Foldit)" != ${phome}/Foldit ]; then
          rm -rf cmp-*
          for f in ${phome}/*; do
            ln -sf "$f" -t .
          done
        fi
        exec ${lib.getExe wrapper} -c 'exec -a "$0" ./Foldit "$@"' "$0" "$@"
        EOF
        chmod +x $out/bin/Foldit

        # required by glibc >= 2.41
        patchelf --clear-execstack $out/opt/Foldit/cmp-binary-*/libtorch_cpu.so

        mkdir -p $out/share/pixmaps
        ln -s ${phome}/cmp-resources-${components.resources.version}/resources/images/big/logo_button.png $out/share/pixmaps/foldit.png

        runHook postInstall
      '';

    desktopItems = [
      (makeDesktopItem {
        name = "Foldit";
        comment = meta.description;
        desktopName = "Foldit";
        genericName = "Foldit";
        exec = "Foldit";
        icon = "foldit";
      })
    ];

    dontFixup = true;
  };

  darwinArgs = {
    src = fetchurl {
      url = "https://web.archive.org/web/20260308095303/https://files.ipd.uw.edu/pub/foldit/Foldit-macos_x64.dmg";
      hash = "sha256-NXi0a0zE6BwYc8/+k9Qj3C3zJe/ikdJCX6ZE4013fpk=";
    };

    nativeBuildInputs = [
      undmg
      unzip
      jq
    ];

    buildPhase = ''
      runHook preBuild

      cd Contents/Resources
      ${buildCommands}
      cd ../..

      runHook postBuild
    '';

    installPhase =
      let
        phome = "$out/Applications/Foldit.app";
      in
      ''
        runHook preInstall

        mkdir -p ${phome}
        cp -r * ${phome}

        runHook postInstall
      '';
  };
in
stdenv.mkDerivation (
  {
    inherit pname version meta;
    strictDeps = true;
    __structuredAttrs = true;
    passthru.updateScript = ./update.sh;
  }
  // {
    x86_64-linux = linuxArgs;
    x86_64-darwin = darwinArgs;
  }
  .${stdenv.hostPlatform.system} or { }
)
