{
  buildDotnetModule,
  buildNpmPackage,
  dotnet-sdk,
  fetchFromGitHub,
  fetchpatch,
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

    patches = [
      # ImmichFrame currently only looks for its config alongside the
      # executable. In nix, this would mean we'd have to recompile the
      # application every time we change its config. This patch adds an
      # environment variable we can use to choose a different place to look for
      # config. See [upstream PR](https://github.com/immichFrame/ImmichFrame/pull/512).
      (fetchpatch {
        name = "Configurable config path";
        url = "https://github.com/immichFrame/ImmichFrame/commit/d39a27cb0cd23a48d388088390cae983e851040e.diff";
        hash = "sha256-JnBNwo7pl61XdE2ELcDts/BCeGb0EtTDCJyORUa/L90=";
      })
      # This patch adds an `ApiKeyFile` option, which makes it possible to
      # configure ImmichFrame without leaking secrets into your configuration.
      # See [upstream PR](https://github.com/immichFrame/ImmichFrame/pull/511)
      (fetchpatch {
        name = "Add a `ApiKeyFile` option";
        url = "https://github.com/immichFrame/ImmichFrame/commit/82e6324384697932fbb0c7dc7aaeed473d933abd.diff";
        hash = "sha256-BVNm6tCkAT6m7UCC/8vr46N0a4oSJOiqcmdIAGcYJ7Q=";
      })
    ];

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
    homepage = "https://immichframe.online";
    license = lib.licenses.gpl3Only;
    maintainers = with lib.maintainers; [ jfly ];
    platforms = lib.platforms.all;
  };
}
