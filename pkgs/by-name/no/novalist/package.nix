{
  lib,
  buildNpmPackage,
  buildDotnetModule,
  buildFHSEnv,
  copyDesktopItems,
  dotnetCorePackages,
  electron_44,
  fetchFromGitHub,
  makeDesktopItem,
  makeWrapper,
  nodejs_24,
}:

let
  electron = electron_44;
in
buildNpmPackage (finalAttrs: {
  pname = "novalist";
  version = "3.7.0";

  __structuredAttrs = true;

  src = fetchFromGitHub {
    owner = "Drommedhar";
    repo = "novalist-official";
    tag = "v${finalAttrs.version}";
    hash = "sha256-kJgV+/LZYzsdV0KuZXnNUYIw/kVho2opASTZrnNDja8=";
  };

  sourceRoot = "${finalAttrs.src.name}/app";

  nodejs = nodejs_24;
  npmDepsHash = "sha256-Pl1RI3sKWnx4vsu/93Rhf+SP/D/oZNfYxAjWrHBJ5OU=";
  npmFlags = [ "--ignore-scripts" ];
  makeCacheWritable = true;

  env.ELECTRON_SKIP_BINARY_DOWNLOAD = "1";

  nativeBuildInputs = [
    copyDesktopItems
    makeWrapper
  ];

  preBuild = ''
    # Upstream only records the released version after tagging
    npm pkg set version=${finalAttrs.version}
  '';

  # `npm run build` also copies DOMPurify into the editor frames
  npmBuildScript = "build";

  installPhase = ''
    runHook preInstall

    # electron-vite bundles every runtime dependency into out/
    mkdir -p $out/share/novalist
    cp -r out package.json resources $out/share/novalist/

    makeWrapper ${lib.getExe electron} $out/bin/novalist \
      --add-flags $out/share/novalist \
      --add-flags "\''${NIXOS_OZONE_WL:+\''${WAYLAND_DISPLAY:+--ozone-platform-hint=auto --enable-features=WaylandWindowDecorations --enable-wayland-ime=true}}" \
      --set NOVALIST_BACKEND_PATH ${lib.getExe finalAttrs.passthru.backendFhs} \
      --set NOVALIST_DISABLE_SELF_UPDATE 1 \
      --inherit-argv0

    install -Dm644 build/icon.png $out/share/icons/hicolor/512x512/apps/novalist.png

    runHook postInstall
  '';

  desktopItems = [
    (makeDesktopItem {
      name = "novalist";
      exec = "novalist %U";
      icon = "novalist";
      desktopName = "Novalist";
      genericName = "Novel Writing";
      comment = finalAttrs.meta.description;
      categories = [
        "Office"
        "WordProcessor"
      ];
      startupWMClass = "Novalist";
    })
  ];

  passthru.backend = buildDotnetModule {
    pname = "${finalAttrs.pname}-backend";
    inherit (finalAttrs) version src;

    __structuredAttrs = true;

    projectFile = "Novalist.Backend/Novalist.Backend.csproj";
    nugetDeps = ./deps.json;

    # Only development tools (Avalonia devtools, API compat checker)
    postPatch = ''
      rm dotnet-tools.json
    '';

    dotnet-sdk = dotnetCorePackages.sdk_10_0;
    dotnet-runtime = dotnetCorePackages.aspnetcore_10_0;

    dotnetFlags = [
      "-p:VersionPrefix=${finalAttrs.version}"
      "-p:ContinuousIntegrationBuild=true"
      "-p:BuildAppleDesktopSpeech=false"
    ];

    executables = [ "Novalist.Backend" ];

    meta = finalAttrs.meta // {
      description = "Backend process of Novalist";
      mainProgram = "Novalist.Backend";
    };
  };

  # The AI Assistant and Speech extensions run inside the backend and download
  # uv, a managed Python and manylinux wheels, which need a standard Linux layout.
  passthru.backendFhs = buildFHSEnv {
    name = "novalist-backend";
    targetPkgs =
      pkgs:
      [
        pkgs.numactl
        pkgs.stdenv.cc.cc.lib
        pkgs.zlib
      ]
      # AMD's ROCm torch wheels expect these on the system instead of bundling them.
      ++ (with pkgs.rocmPackages; [
        clr
        hipblas
        hipblaslt
        hipfft
        hiprand
        hipsolver
        hipsparse
        hipsparselt
        miopen
        rccl
        rocblas
        rocsolver
        roctracer
      ]);
    runScript = lib.getExe finalAttrs.passthru.backend;
    meta.mainProgram = "novalist-backend";
  };

  meta = {
    description = "Offline-first desktop application for writing novels";
    homepage = "https://github.com/Drommedhar/novalist-official";
    changelog = "https://github.com/Drommedhar/novalist-official/blob/v${finalAttrs.version}/CHANGELOG.md";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ qf0xb ];
    mainProgram = "novalist";
    platforms = lib.platforms.linux;
  };
})
