{
  lib,
  pkgs,
  buildDotnetModule,
  emptyDirectory,
  stdenv,
  mkNugetDeps,
}: let
  nugetName = "JetBrains.ReSharper.GlobalTools";
  version = "2023.3.3";
  nugetSha256 = "sha256-Nn3imJvnqLe02gR1GyUHYH4+XkrNnhLy9dyCjJCkB7M=";
  pname = "jb";
in
  buildDotnetModule {
    inherit nugetName version nugetSha256 pname;

    src = emptyDirectory;

    executables = "jb";

    dotnet-runtime = pkgs.dotnet-sdk;

    nugetDeps = mkNugetDeps {
      name = pname;
      nugetDeps = {fetchNuGet}: [
        (fetchNuGet {
          pname = nugetName;
          inherit version;
          sha256 = nugetSha256;
        })
      ];
    };

    projectFile = "";

    useDotnetFromEnv = true;

    dontBuild = true;

    installPhase = ''
      runHook preInstall

      dotnet tool install --tool-path $out/lib/${pname} ${nugetName} ${
        if stdenv.isAarch64
        then "--arch arm64"
        else ""
      }

      # remove files that contain nix store paths to temp nuget sources we made
      find $out -name 'project.assets.json' -delete
      find $out -name '.nupkg.metadata' -delete

      runHook postInstall
    '';

    meta = with lib; {
      homepage = "https://www.jetbrains.com/help/resharper/ReSharper_Command_Line_Tools.html";
      changelog = "https://www.jetbrains.com/resharper/whatsnew/";
      license = licenses.unfree;
      platforms = platforms.unix;
      maintainers = with maintainers; [tarantoj];
      mainProgram = "jb";
    };
  }
