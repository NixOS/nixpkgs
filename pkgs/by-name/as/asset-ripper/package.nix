{
  autoPatchelfHook,
  buildDotnetModule,
  dbus,
  dotnetCorePackages,
  fetchFromGitHub,
  lib,
}:

buildDotnetModule (finalAttrs: {
  pname = "AssetRipper";
  version = "1.1.3";

  src = fetchFromGitHub {
    owner = "AssetRipper";
    repo = "AssetRipper";
    rev = "refs/tags/${finalAttrs.version}";
    hash = "sha256-KSCM4HY+IjbWnhfOiTxp3WEJPjeOgPo4r9p1CjvBshs=";
  };

  # Until https://github.com/AssetRipper/AssetRipper/issues/1414 is resolved.
  patches = [ ./replace-ro-exe-dir-with-cwd.patch ];

  buildInputs = [ dbus.lib ];

  nativeBuildInputs = [ autoPatchelfHook ];

  # Prevent automatic patching of all files. This is necessary as applying
  # autoPatchelf indiscriminately causes dangling references to openssl and
  # icu4c in AssetRipper.GUI.Free
  dontAutoPatchelf = true;

  # Patch some prebuilt libraries fetched via NuGet.
  fixupPhase = ''
    runHook preFixup

    autoPatchelf $out/lib/AssetRipper/libnfd.so
    autoPatchelf $out/lib/AssetRipper/libTexture2DDecoderNative.so

    runHook postFixup
  '';

  projectFile = "Source/AssetRipper.GUI.Free/AssetRipper.GUI.Free.csproj";

  # Error: "PublishTrimmed is implied by native compilation and cannot be disabled."
  # We need to override the project settings and disable native AoT compilation
  # as this is incompatible with PublishTrimmed.
  dotnetInstallFlags = [ "-p:PublishAot=false" ];

  nugetDeps = ./deps.nix;

  executables = [ "AssetRipper.GUI.Free" ];

  dotnet-sdk = dotnetCorePackages.sdk_8_0;
  dotnet-runtime = dotnetCorePackages.aspnetcore_8_0;

  meta = {
    description = "Tool for extracting assets from Unity serialized files and asset bundles";
    homepage = "https://github.com/AssetRipper/AssetRipper";
    license = lib.licenses.gpl3Only;
    mainProgram = "AssetRipper.GUI.Free";
    maintainers = with lib.maintainers; [ diadatp ];
    platforms = lib.platforms.unix;
  };
})
