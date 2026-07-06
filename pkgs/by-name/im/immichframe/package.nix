{
  buildDotnetModule,
  buildNpmPackage,
  dotnet-sdk,
  fetchFromGitHub,
  fetchpatch,
  lib,
  nixosTests,
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
      # This not-yet-released commit has landed upstream. It adds a
      # `IMMICHFRAME_CONFIG_PATH` environment variable for a "configurable"
      # config path.
      (fetchpatch {
        name = "Configurable config path";
        url = "https://github.com/immichFrame/ImmichFrame/commit/f6680f23bcf107ce27372dfb37809c0f92ebb2f2.patch";
        hash = "sha256-dQnspQEKixQgBpCvNxrYL51z5wg5BhdN0uTuaXgKQZU=";
      })
      # This patch adds an `ApiKeyFile` option, which makes it possible to
      # configure ImmichFrame without leaking secrets into your configuration.
      # See [upstream PR](https://github.com/immichFrame/ImmichFrame/pull/511)
      (fetchpatch {
        name = "Add a `ApiKeyFile` option";
        url = "https://github.com/immichFrame/ImmichFrame/commit/f5bb164170460b1020bfe6bce8e8abb3315e32e3.diff";
        hash = "sha256-F3BVIxcu8Hm6wbWmzVnfgm6XvqdBw4IiS61CDQiMRVg=";
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

  passthru.tests = { inherit (nixosTests) immichframe; };

  meta = {
    description = "Display your photos from Immich as a digital photo frame";
    homepage = "https://immichframe.dev";
    license = lib.licenses.gpl3Only;
    maintainers = with lib.maintainers; [ jfly ];
    platforms = lib.platforms.all;
  };
}
