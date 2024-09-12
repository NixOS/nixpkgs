{ lib
, stdenv
, fetchurl
, appimageTools
, unzip
, makeWrapper
# Notice: graphs will not sync without matching upstream's major electron version
#         the specific electron version is set at top-level file to preserve override interface.
#         whenever updating this package also sync electron version at top-level file.
, electron
, autoPatchelfHook
, git
, nix-update-script
}:

stdenv.mkDerivation (finalAttrs: let
  inherit (finalAttrs) pname version src;
  inherit (stdenv.hostPlatform) system;
  selectSystem = attrs: attrs.${system} or (throw "Unsupported system: ${system}");
  suffix = selectSystem {
    x86_64-linux = "linux-x64-${version}.AppImage";
    x86_64-darwin = "darwin-x64-${version}.zip";
    aarch64-darwin = "darwin-arm64-${version}.zip";
  };
  hash = selectSystem {
    x86_64-linux = "sha256-XROuY2RlKnGvK1VNvzauHuLJiveXVKrIYPppoz8fCmc=";
    x86_64-darwin = "sha256-0i9ozqBSeV/y8v+YEmQkbY0V6JHOv6tKub4O5Fdx2fQ=";
    aarch64-darwin = "sha256-Uvv96XWxpFj14wPH0DwPT+mlf3Z2dy1g/z8iBt5Te7Q=";
  };
in {
  pname = "logseq";
  version = "0.10.9";
  src = fetchurl {
    inherit hash;
    url = "https://github.com/logseq/logseq/releases/download/${version}/logseq-${suffix}";
    name = lib.optionalString stdenv.isLinux "logseq-${version}.AppImage";
  };

  nativeBuildInputs = [ makeWrapper ]
    ++ lib.optionals stdenv.isLinux [ autoPatchelfHook ]
    ++ lib.optionals stdenv.isDarwin [ unzip ];
  buildInputs = [ stdenv.cc.cc.lib ];

  dontUnpack = stdenv.isLinux;
  dontConfigure = true;
  dontBuild = true;

  installPhase = ''
    runHook preInstall
  '' + lib.optionalString stdenv.isLinux (
  let
   appimageContents = appimageTools.extract { inherit pname src version; };
  in
  ''
    mkdir -p $out/bin $out/share/logseq $out/share/applications
    cp -a ${appimageContents}/{locales,resources} $out/share/logseq
    cp -a ${appimageContents}/Logseq.desktop $out/share/applications/logseq.desktop

    # remove the `git` in `dugite` because we want the `git` in `nixpkgs`
    chmod +w -R $out/share/logseq/resources/app/node_modules/dugite/git
    chmod +w $out/share/logseq/resources/app/node_modules/dugite
    rm -rf $out/share/logseq/resources/app/node_modules/dugite/git
    chmod -w $out/share/logseq/resources/app/node_modules/dugite

    mkdir -p $out/share/pixmaps
    ln -s $out/share/logseq/resources/app/icons/logseq.png $out/share/pixmaps/logseq.png

    substituteInPlace $out/share/applications/logseq.desktop \
      --replace Exec=Logseq Exec=logseq \
      --replace Icon=Logseq Icon=logseq
  '') + lib.optionalString stdenv.isDarwin ''
    mkdir -p $out/{Applications/Logseq.app,bin}
    cp -R . $out/Applications/Logseq.app
    makeWrapper $out/Applications/Logseq.app/Contents/MacOS/Logseq $out/bin/logseq
  '' + ''
    runHook postInstall
  '';

  postFixup = lib.optionalString stdenv.isLinux ''
    # set the env "LOCAL_GIT_DIRECTORY" for dugite so that we can use the git in nixpkgs
    makeWrapper ${electron}/bin/electron $out/bin/logseq \
      --set "LOCAL_GIT_DIRECTORY" ${git} \
      --add-flags $out/share/logseq/resources/app \
      --add-flags "\''${NIXOS_OZONE_WL:+\''${WAYLAND_DISPLAY:+--ozone-platform-hint=auto --enable-features=WaylandWindowDecorations}}"
  '';

  passthru.updateScript = nix-update-script { };

  meta = {
    description = "Local-first, non-linear, outliner notebook for organizing and sharing your personal knowledge base";
    homepage = "https://github.com/logseq/logseq";
    changelog = "https://github.com/logseq/logseq/releases/tag/${version}";
    license = lib.licenses.agpl3Plus;
    sourceProvenance = with lib.sourceTypes; [ binaryNativeCode ];
    maintainers = with lib.maintainers; [ cheeseecake ];
    platforms = [ "x86_64-linux" ] ++ lib.platforms.darwin;
    mainProgram = "logseq";
  };
})
