{
  lib,
  fetchFromGitHub,
  nixosTests,
  dotnetCorePackages,
  buildDotnetModule,
  jellyfin-ffmpeg,
  fontconfig,
  freetype,
  jellyfin-web,
  sqlite,
  versionCheckHook,
  jq,
}:

buildDotnetModule (finalAttrs: {
  pname = "jellyfin";
  version = "10.11.11"; # ensure that jellyfin-web has matching version

  src = fetchFromGitHub {
    owner = "jellyfin";
    repo = "jellyfin";
    tag = "v${finalAttrs.version}";
    hash = "sha256-HCs4ZsutVoVH+bBZANjpPeMyV8e63Yemjg9DSr0R9zg=";
  };

  nativeBuildInputs = [
    jq
  ];

  propagatedBuildInputs = [ sqlite ];

  projectFile = "Jellyfin.Server/Jellyfin.Server.csproj";
  executables = [ "jellyfin" ];
  nugetDeps = ./nuget-deps.json;
  runtimeDeps = [
    jellyfin-ffmpeg
    fontconfig
    freetype
  ];
  dotnet-sdk = dotnetCorePackages.sdk_9_0;
  dotnet-runtime = dotnetCorePackages.aspnetcore_9_0;
  dotnetBuildFlags = [ "--no-self-contained" ];

  makeWrapperArgs = [
    "--add-flags"
    "--ffmpeg=${jellyfin-ffmpeg}/bin/ffmpeg"
    "--add-flags"
    "--webdir=${jellyfin-web}/share/jellyfin-web"
  ];

  # Impurity with time. Injects the build date into this file
  postFixup = ''
    timestamp="$(TZ=GMT date -d "@$SOURCE_DATE_EPOCH" '+%a, %d %b %Y %X GMT')"

    cat "$out/lib/jellyfin/jellyfin.staticwebassets.endpoints.json" \
      | jq --arg timestamp "$timestamp" '.Endpoints[].ResponseHeaders[] |= if (.Name == "Last-Modified") then .Value = $timestamp else . end' \
      > jellyfin.staticwebassets.endpoints.json.new

    mv "jellyfin.staticwebassets.endpoints.json.new" "$out/lib/jellyfin/jellyfin.staticwebassets.endpoints.json"
  '';

  nativeInstallCheckInputs = [
    versionCheckHook
  ];
  doInstallCheck = true;

  passthru.tests = {
    smoke-test = nixosTests.jellyfin;
  };

  passthru.updateScript = ./update.sh;

  meta = {
    description = "Free Software Media System";
    homepage = "https://jellyfin.org/";
    # https://github.com/jellyfin/jellyfin/issues/610#issuecomment-537625510
    license = lib.licenses.gpl2Plus;
    maintainers = with lib.maintainers; [
      nyanloutre
      minijackson
      purcell
      jojosch
    ];
    mainProgram = "jellyfin";
    platforms = finalAttrs.dotnet-runtime.meta.platforms;
  };
})
