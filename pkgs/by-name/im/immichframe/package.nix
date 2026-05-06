{
  buildDotnetModule,
  buildNpmPackage,
  dotnet-sdk,
  fetchFromGitHub,
  lib,
  nixosTests,
  writeShellApplication,
  _experimental-update-script-combinators,
  nix-update-script,
}:

let
  version = "1.0.33.0";
  src = fetchFromGitHub {
    owner = "immichFrame";
    repo = "immichFrame";
    rev = "v${version}";
    hash = "sha256-b8hfzNZJz9XCRO4UfzwK5OsrgqV2F5wnZlRH7h3Eo9Q=";
  };

  api = buildDotnetModule {
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
    npmDepsHash = "sha256-PjbbBpYYUHH4oucJuk0FCdJa0LzTlkQnjkZ5MLziqTY=";

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
    exec ${lib.getExe api} "$@"
  '';

  passthru = {
    inherit api frontend;
    updateScript = _experimental-update-script-combinators.sequence [
      (nix-update-script { attrPath = "immichframe.api"; })
      (nix-update-script {
        attrPath = "immichframe.frontend";
        extraArgs = [ "--version=skip" ];
      })
    ];
    tests = { inherit (nixosTests) immichframe; };
  };

  meta = {
    description = "Display your photos from Immich as a digital photo frame";
    homepage = "https://immichframe.dev";
    license = lib.licenses.gpl3Only;
    maintainers = with lib.maintainers; [ jfly ];
    platforms = lib.platforms.all;
  };
}
