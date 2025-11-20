{
  buildDotnetModule,
  buildNpmPackage,
  dotnet-sdk,
  fetchFromGitHub,
  lib,
  writeShellApplication,
}:

let
  version = "1.0.29.0";
  src = fetchFromGitHub {
    owner = "immichFrame";
    repo = "immichFrame";
    rev = "v${version}";
    hash = "sha256-YFh+/QWYYtQzBVJUyUuhhKqi9/5waWVX+lw/tov++ws=";
  };

  publishApi = buildDotnetModule {
    pname = "immichframe";
    inherit version src;
    projectFile = "ImmichFrame.WebApi/ImmichFrame.WebApi.csproj";
    nugetDeps = ./deps.json;
    dotnet-runtime = dotnet-sdk.aspnetcore;

    meta.mainProgram = "ImmichFrame.WebApi";
  };

  frontend = buildNpmPackage {
    pname = "immichframe-frontend";
    inherit version src;

    sourceRoot = "${src.name}/immichFrame.Web";

    npmBuildScript = "build";
    npmDepsHash = "sha256-eOv3DlmHaI6hVCYTBzCtLWKD72/RM/KjCUDVUgb9jcg=";

    installPhase = ''
      runHook preInstall

      mkdir $out
      cp -r build/ $out/wwwroot

      runHook postInstall
    '';
  };
in
writeShellApplication {
  name = "ImmichFrame";

  text = ''
    cd ${frontend}
    exec ${lib.getExe publishApi} "$@"
  '';

  meta = {
    description = "Display your photos from Immich as a digital photo frame";
    homepage = "https://immichframe.dev";
    license = lib.licenses.gpl3Only;
    maintainers = with lib.maintainers; [ jfly ];
    platforms = lib.platforms.all;
  };
}
