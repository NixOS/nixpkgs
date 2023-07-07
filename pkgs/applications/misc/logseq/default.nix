{ lib
, stdenv
, fetchurl
, appimageTools
, makeWrapper
, electron
, git
, nix-update-script
}:

stdenv.mkDerivation rec {
  pname = "logseq";
  version = "0.9.10";

  src = fetchurl {
    url = "https://github.com/logseq/logseq/releases/download/${version}/logseq-linux-x64-${version}.AppImage";
    hash = "sha256-en8ws0qdMY5j1o8oTkKcIHHQV+kCuQZzQbdFU97qAQE=";
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
    cp -a ${appimageContents}/Logseq.desktop $out/share/applications/${pname}.desktop

    # remove the `git` in `dugite` because we want the `git` in `nixpkgs`
    chmod +w -R $out/share/${pname}/resources/app/node_modules/dugite/git
    chmod +w $out/share/${pname}/resources/app/node_modules/dugite
    rm -rf $out/share/${pname}/resources/app/node_modules/dugite/git
    chmod -w $out/share/${pname}/resources/app/node_modules/dugite

    mkdir -p $out/share/pixmaps
    ln -s $out/share/${pname}/resources/app/icons/logseq.png $out/share/pixmaps/${pname}.png

    substituteInPlace $out/share/applications/${pname}.desktop \
      --replace Exec=Logseq Exec=${pname} \
      --replace Icon=Logseq Icon=${pname}

    runHook postInstall
  '';

  postFixup = ''
    # set the env "LOCAL_GIT_DIRECTORY" for dugite so that we can use the git in nixpkgs
    makeWrapper ${electron}/bin/electron $out/bin/${pname} \
      --set "LOCAL_GIT_DIRECTORY" ${git} \
      --add-flags $out/share/${pname}/resources/app \
      --add-flags "\''${NIXOS_OZONE_WL:+\''${WAYLAND_DISPLAY:+--ozone-platform-hint=auto --enable-features=WaylandWindowDecorations}}"
  '';

  passthru.updateScript = nix-update-script { };

  meta = with lib; {
    description = "A local-first, non-linear, outliner notebook for organizing and sharing your personal knowledge base";
    homepage = "https://github.com/logseq/logseq";
    changelog = "https://github.com/logseq/logseq/releases/tag/${version}";
    license = licenses.agpl3Plus;
    maintainers = with maintainers; [ ];
    platforms = [ "x86_64-linux" ];
  };
}
