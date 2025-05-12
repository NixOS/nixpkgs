{
  lib,
  stdenv,
  buildDotnetModule,
  buildNpmPackage,
  curl,
  dotnetCorePackages,
  fetchFromGitHub,
  makeDesktopItem,
  copyDesktopItems,
  nix-update-script,
  nodejs_22,
  writeShellScriptBin,

  legendsviewer-next,
}:
let
  dotnet-sdk = dotnetCorePackages.sdk_8_0;
  dotnet-runtime = dotnetCorePackages.aspnetcore_8_0;
  frontend = import ./frontend.nix {
    nodejs = nodejs_22;
    inherit buildNpmPackage legendsviewer-next;
  };
in
buildDotnetModule rec {
  pname = "legendsviewer-next";
  version = "1.2.0";

  desktopItems = [
    (makeDesktopItem {
      name = pname;
      desktopName = "Legends Viewer";
      genericName = "DF Legends Export Browser";
      comment = meta.description;
      icon = "${frontend}/dist/ceretelina.png";
      tryExec = "LegendsViewer";
      exec = "LegendsViewer";

      # Until upstream supports multiple launches, we need a terminal to keep
      # track of if it's already launched.
      terminal = true;

      categories = [
        "Game"
        "RolePlaying"
        "Simulation"
      ];
      keywords = [
        "df"
        "dwarf"
        "fortress"
        "legends"
        "viewer"
      ];
    })
  ];

  src = fetchFromGitHub {
    owner = "Kromtec";
    repo = "LegendsViewer-Next";
    tag = "v${version}";
    hash = "sha256-Fi4KARGsgDmplH/oG9OIxY2XqhHNYgUB6OxwtoTaCt4=";
  };

  nugetDeps = ./deps.json;
  projectFile = "./LegendsViewer.Backend/LegendsViewer.Backend.csproj";
  testProjectFile = "./LegendsViewer.Backend.Tests/LegendsViewer.Backend.Tests.csproj";
  executables = [ meta.mainProgram ];
  inherit dotnet-sdk dotnet-runtime;

  nativeBuildInputs = [
    # This fixes a build failure, we don't care about the frontend node build here
    (writeShellScriptBin "npm" "")

    copyDesktopItems
  ];

  installPhase = ''
    runHook preInstall

    lib=$out/lib/${pname}

    mkdir -p $lib

    cp ./LegendsViewer.Backend/bin/Release/net8.0/*/* $lib
    ln -s ${frontend} $lib/${frontend.pname}

    runHook postInstall
  '';

  passthru = {
    updateScript = nix-update-script {
      extraArgs = [ "--subpackage frontend" ];
    };
    tests = {
      test = stdenv.mkDerivation {
        pname = "${pname}-test";
        inherit version;

        nativeBuildInputs = [
          curl
          legendsviewer-next
        ];

        dontUnpack = true;
        dontPatch = true;
        dontConfigure = true;

        buildPhase = ''
          runHook preBuild

          timeout 10 LegendsViewer &
          sleep 2

          # Static server is up
          curl -f http://localhost:8081 | grep "<!doctype html>"

          # Version matches expected
          curl -f http://localhost:5054/api/version | grep ${version}

          echo > $out

          runHook postBuild
        '';

        dontCheck = true;
        dontInstall = true;
        dontFixup = true;
      };
    };
  };

  meta = {
    description = "Recreates Dwarf Fortress' Legends Mode from exported files";
    homepage = "https://github.com/${src.owner}/${src.repo}";
    license = lib.licenses.mit;

    mainProgram = "LegendsViewer";
    platforms = with lib.platforms; lib.intersectLists (darwin ++ linux) (x86_64 ++ aarch64);

    maintainers = with lib.maintainers; [ donottellmetonottellyou ];
  };
}
