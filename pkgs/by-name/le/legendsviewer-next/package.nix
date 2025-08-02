{
  patches ? [ ],

  lib,
  dotnetCorePackages,
  curl,

  buildDotnetModule,
  callPackage,
  copyDesktopItems,
  fetchFromGitHub,
  makeDesktopItem,
  nix-update-script,
  writeShellScriptBin,
}:
let
  version = "1.2.0";

  src = fetchFromGitHub {
    owner = "Kromtec";
    repo = "LegendsViewer-Next";
    tag = "v${version}";
    hash = "sha256-Fi4KARGsgDmplH/oG9OIxY2XqhHNYgUB6OxwtoTaCt4=";
  };

  frontend = callPackage ./frontend.nix {
    inherit version src patches;
  };
in
buildDotnetModule rec {
  pname = "legendsviewer-next";
  inherit version src patches;

  desktopItems = [
    (makeDesktopItem {
      name = pname;
      desktopName = "Legends Viewer";
      genericName = "DF Legends Export Browser";
      comment = meta.description;
      icon = "${frontend}/dist/ceretelina.png";
      tryExec = meta.mainProgram;
      exec = meta.mainProgram;

      # Remove when https://github.com/Kromtec/LegendsViewer-Next/pull/55 gets
      # released
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

  dotnet-sdk = dotnetCorePackages.sdk_8_0;
  dotnet-runtime = dotnetCorePackages.aspnetcore_8_0;
  nugetDeps = ./deps.json;
  projectFile = "./LegendsViewer.Backend/LegendsViewer.Backend.csproj";
  testProjectFile = "./LegendsViewer.Backend.Tests/LegendsViewer.Backend.Tests.csproj";
  executables = [ meta.mainProgram ];

  nativeBuildInputs = [
    copyDesktopItems
    # Fixes a build failure, the frontend node build is handled in ./frontend.nix
    (writeShellScriptBin "npm" "")
  ];

  installPhase = ''
    runHook preInstall

    lib=$out/lib/${pname}

    mkdir -p $lib

    cp ./LegendsViewer.Backend/bin/Release/*/*/* $lib
    ln -s ${frontend} $lib/${frontend.pname}

    runHook postInstall
  '';

  doInstallCheck = true;

  nativeInstallCheckInputs = [
    curl
  ];

  installCheckPhase = ''
    runHook preInstallCheck

    timeout 10 $out/bin/LegendsViewer &
    sleep 5

    # Static server is up
    curl -f http://localhost:8081 | grep "<!doctype html>"

    # Version matches expected
    curl -f http://localhost:5054/api/version | grep ${version}

    runHook postInstallCheck
  '';

  passthru = {
    updateScript = nix-update-script { };
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
