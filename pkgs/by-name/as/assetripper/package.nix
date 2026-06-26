{
  lib,
  stdenv,
  autoPatchelfHook,
  buildDotnetModule,
  fetchFromGitHub,
  dbus,
  dotnetCorePackages,
  nix-update-script,
}:

buildDotnetModule (finalAttrs: {
  pname = "assetripper";
  version = "1.3.14";

  src = fetchFromGitHub {
    owner = "AssetRipper";
    repo = "AssetRipper";
    tag = finalAttrs.version;
    hash = "sha256-bRz+kvDSPxyt8CNn6sszEcMIxgNNv4FQRFO7zFglPkU=";
  };

  buildInputs = [
    dbus
    (lib.getLib stdenv.cc.cc)
  ];

  nativeBuildInputs = [ autoPatchelfHook ];

  # Prevent automatic patching of all files. This is necessary as applying
  # autoPatchelf indiscriminately causes dangling references to openssl and
  # icu4c in AssetRipper.GUI.Free
  dontAutoPatchelf = true;

  # Avoid IOException on startup
  makeWrapperArgs = [
    "--add-flags"
    "--log=false"
  ];

  # Make the main executable available under a more intuitive name.
  postInstall = ''
    mkdir -p $out/bin
    ln -rs $out/bin/AssetRipper.GUI.Free $out/bin/AssetRipper
  '';

  # Patch some prebuilt libraries fetched via NuGet.
  fixupPhase = lib.optionalString stdenv.hostPlatform.isLinux ''
    runHook preFixup

    autoPatchelf $out/lib/assetripper/libnfd.so
    autoPatchelf $out/lib/assetripper/libTexture2DDecoderNative.so

    runHook postFixup
  '';

  projectFile = "Source/AssetRipper.GUI.Free/AssetRipper.GUI.Free.csproj";

  # Error: "PublishTrimmed is implied by native compilation and cannot be disabled."
  # We need to override the project settings and disable native AoT compilation
  # as this is incompatible with PublishTrimmed.
  dotnetInstallFlags = [ "-p:PublishAot=false" ];

  nugetDeps = ./deps.json;

  executables = [ "AssetRipper.GUI.Free" ];

  dotnet-sdk = dotnetCorePackages.sdk_10_0;
  dotnet-runtime = finalAttrs.dotnet-sdk.aspnetcore;

  passthru.updateScript = nix-update-script { };

  meta = {
    description = "Tool for extracting assets from Unity serialized files and asset bundles";
    homepage = "https://github.com/AssetRipper/AssetRipper";
    license = lib.licenses.gpl3Only;
    mainProgram = "AssetRipper";
    maintainers = with lib.maintainers; [
      YoshiRulz
      toasteruwu
    ];
    platforms = lib.platforms.unix;
    sourceProvenance = with lib.sourceTypes; [
      fromSource
      binaryNativeCode # libraries fetched by NuGet
    ];
  };
})
