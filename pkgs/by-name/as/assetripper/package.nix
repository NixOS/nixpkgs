{
  lib,
  stdenv,
  autoPatchelfHook,
  buildDotnetModule,
  fetchFromGitHub,
  dbus,
  dotnetCorePackages,
}:

buildDotnetModule (finalAttrs: {
  pname = "assetripper";
  version = "1.3.0";

  src = fetchFromGitHub {
    owner = "AssetRipper";
    repo = "AssetRipper";
    tag = finalAttrs.version;
    hash = "sha256-ixXWbygFhvOjld+YRLIhkO3cgDNkQsbivri2pjU4rgM=";
  };

  postPatch = ''
    sed 's@Path.Join(ExecutingDirectory, "temp",@Path.Join(Path.GetTempPath(), "AssetRipper",@' \
      -i Source/AssetRipper.IO.Files/Utils/TemporaryFileStorage.cs
  '';

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

    autoPatchelf $out/lib/${finalAttrs.pname}/libnfd.so
    autoPatchelf $out/lib/${finalAttrs.pname}/libTexture2DDecoderNative.so

    runHook postFixup
  '';

  projectFile = "Source/AssetRipper.GUI.Free/AssetRipper.GUI.Free.csproj";

  # Error: "PublishTrimmed is implied by native compilation and cannot be disabled."
  # We need to override the project settings and disable native AoT compilation
  # as this is incompatible with PublishTrimmed.
  dotnetInstallFlags = [ "-p:PublishAot=false" ];

  nugetDeps = ./deps.json;

  executables = [ "AssetRipper.GUI.Free" ];

  dotnet-sdk = dotnetCorePackages.sdk_9_0;
  dotnet-runtime = finalAttrs.dotnet-sdk.aspnetcore;

  meta = {
    description = "Tool for extracting assets from Unity serialized files and asset bundles";
    homepage = "https://github.com/AssetRipper/AssetRipper";
    license = lib.licenses.gpl3Only;
    mainProgram = "AssetRipper";
    maintainers = with lib.maintainers; [ YoshiRulz ];
    platforms = lib.platforms.unix;
    sourceProvenance = with lib.sourceTypes; [
      fromSource
      binaryNativeCode # libraries fetched by NuGet
    ];
  };
})
