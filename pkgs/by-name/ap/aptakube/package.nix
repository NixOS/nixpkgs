{
  lib,
  stdenvNoCC,
  fetchurl,

  autoPatchelfHook,
  dpkg,
  makeBinaryWrapper,
  undmg,
  wrapGAppsHook3,

  glib-networking,
  webkitgtk_4_1,

  kubectl,
  kubernetes-helm,
  extraPath ? [ ],
}:

stdenvNoCC.mkDerivation (
  finalAttrs:
  let
    sources = {
      aarch64-darwin = {
        name = "Aptakube_${finalAttrs.version}_universal.dmg";
        hash = "sha256-JWDwsvqZnEQc6Ne+aC2WbdMaEO20f8AEK7SlC3lEzUk=";
      };
      x86_64-linux = {
        name = "aptakube_${finalAttrs.version}_amd64.deb";
        hash = "sha256-JooC/fwy1zaIU2UAmDooejEbBmCChVrJ2rTsn0M8WaI=";
      };
    };

    source =
      sources.${stdenvNoCC.hostPlatform.system}
        or (throw "aptakube: unsupported system ${stdenvNoCC.hostPlatform.system}");

    runtimePath = extraPath ++ [
      kubectl
      kubernetes-helm
    ];
  in
  {
    pname = "aptakube";
    version = "1.18.8";

    __structuredAttrs = true;
    strictDeps = true;

    src = fetchurl {
      url = "https://github.com/aptakube/aptakube/releases/download/${finalAttrs.version}/${source.name}";
      inherit (source) hash;
    };

    sourceRoot = if stdenvNoCC.hostPlatform.isDarwin then "." else "root";

    nativeBuildInputs =
      lib.optionals stdenvNoCC.hostPlatform.isLinux [
        autoPatchelfHook
        dpkg
        wrapGAppsHook3
      ]
      ++ lib.optionals stdenvNoCC.hostPlatform.isDarwin [
        makeBinaryWrapper
        undmg
      ];

    buildInputs = lib.optionals stdenvNoCC.hostPlatform.isLinux [
      glib-networking
      webkitgtk_4_1
    ];

    dontConfigure = true;
    dontBuild = true;

    installPhase =
      if stdenvNoCC.hostPlatform.isLinux then
        ''
          runHook preInstall

          mkdir -p $out
          mv usr/bin usr/share $out/
          substituteInPlace $out/share/applications/aptakube.desktop \
            --replace-fail 'Name=aptakube' 'Name=Aptakube'

          runHook postInstall
        ''
      else
        ''
          runHook preInstall

          mkdir -p $out/Applications $out/bin
          cp -R Aptakube.app $out/Applications/
          makeWrapper $out/Applications/Aptakube.app/Contents/MacOS/Aptakube \
            $out/bin/aptakube \
            --suffix PATH : ${lib.makeBinPath runtimePath}

          runHook postInstall
        '';

    preFixup = lib.optionalString stdenvNoCC.hostPlatform.isLinux ''
      gappsWrapperArgs+=(--suffix PATH : ${lib.makeBinPath runtimePath})
    '';

    passthru = {
      inherit sources;
      updateScript = ./update.sh;
    };

    meta = {
      description = "Multi-cluster Kubernetes UI";
      longDescription = ''
        Aptakube is proprietary software with a 15-day free trial.

        Some operations use `kubectl` or Helm from `PATH`. If they are not in
        `PATH`, packaged binaries will be used.

        Any kubeconfig exec-auth helpers are loaded from `PATH`. Use `extraPath`
        to modify `PATH` specifically for this package.
      '';

      homepage = "https://aptakube.com/";
      downloadPage = "https://github.com/aptakube/aptakube/releases";
      changelog = "https://github.com/aptakube/aptakube/releases/tag/${finalAttrs.version}";

      license = lib.licenses.unfree;
      sourceProvenance = [ lib.sourceTypes.binaryNativeCode ];

      mainProgram = "aptakube";
      maintainers = with lib.maintainers; [
        juliamertz
        maximsmol
      ];
      platforms = builtins.attrNames sources;
    };
  }
)
