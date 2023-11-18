{ lib
, stdenv
, fetchurl
, appimageTools
, makeWrapper
# graphs will not sync without matching upstream's major electron version
, electron_25
, git
, nix-update-script
, undmg
, unzip
}:

stdenv.mkDerivation (finalAttrs: let
  inherit (finalAttrs) pname version src appimageContents;

  appname = "Logseq";

  linux = {
    src = fetchurl {
      url = "https://github.com/logseq/logseq/releases/download/${version}/logseq-linux-x64-${version}.AppImage";
      hash = "sha256-iT0Gc/ePx1tUNTPoE2Ol+dHUmbS4CkneZbyraRBx5Ak=";
      name = "${pname}-${version}.AppImage";
    };

    appimageContents = appimageTools.extract {
      inherit pname src version;
    };

    dontUnpack = true;
    dontConfigure = true;
    dontBuild = true;

    nativeBuildInputs = [ makeWrapper ];

    installPhase = ''
      runHook preInstall

      mkdir -p $out/bin $out/share/${pname} $out/share/applications
      cp -a ${appimageContents}/{locales,resources} $out/share/${pname}
      cp -a ${appimageContents}/${appname}.desktop $out/share/applications/${pname}.desktop

      # remove the `git` in `dugite` because we want the `git` in `nixpkgs`
      chmod +w -R $out/share/${pname}/resources/app/node_modules/dugite/git
      chmod +w $out/share/${pname}/resources/app/node_modules/dugite
      rm -rf $out/share/${pname}/resources/app/node_modules/dugite/git
      chmod -w $out/share/${pname}/resources/app/node_modules/dugite

      mkdir -p $out/share/pixmaps
      ln -s $out/share/${pname}/resources/app/icons/logseq.png $out/share/pixmaps/${pname}.png

      substituteInPlace $out/share/applications/${pname}.desktop \
        --replace Exec=${appname} Exec=${pname} \
        --replace Icon=${appname} Icon=${pname}

      runHook postInstall
    '';

    postFixup = ''
      # set the env "LOCAL_GIT_DIRECTORY" for dugite so that we can use the git in nixpkgs
      makeWrapper ${electron_25}/bin/electron $out/bin/${pname} \
        --set "LOCAL_GIT_DIRECTORY" ${git} \
        --add-flags $out/share/${pname}/resources/app \
        --add-flags "\''${NIXOS_OZONE_WL:+\''${WAYLAND_DISPLAY:+--ozone-platform-hint=auto --enable-features=WaylandWindowDecorations}}" \
        --prefix LD_LIBRARY_PATH : "${lib.makeLibraryPath [ stdenv.cc.cc.lib ]}"
    '';
  };

  darwin = {
    src = fetchurl {
      url =  "https://github.com/logseq/logseq/releases/download/${version}/logseq-darwin-arm64-${version}.dmg";
      hash = "sha256-h5I1ZSIdo7yGfhryJSyvQFSo0OIPfcFxfDoSIaI48IM=";
      name = "${pname}-${version}.dmg";
    };

    nativeBuildInputs = [ makeWrapper undmg unzip ];

    installPhase = ''
      runHook preinstall

      mkdir -p $out/{bin,Applications/${appname}.app}
      cp -R . $out/Applications/${appname}.app
      makeWrapper $out/Applications/${appname}.app/Contents/MacOS/${appname} $out/bin/${pname}

      runHook postInstall
    '';
  };
in (if stdenv.isLinux then linux else darwin) // {
  pname = "logseq";
  version = "0.9.20";

  passthru.updateScript = nix-update-script { };

  meta = with lib; {
    description = "A local-first, non-linear, outliner notebook for organizing and sharing your personal knowledge base";
    homepage = "https://github.com/logseq/logseq";
    changelog = "https://github.com/logseq/logseq/releases/tag/${version}";
    license = licenses.agpl3Plus;
    maintainers = with maintainers; [
      cdmistman
    ];
    platforms = [
      "aarch64-darwin"
      "x86_64-linux"
    ];
  };
})
