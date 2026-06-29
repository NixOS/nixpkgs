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
}:
let
  version = "1.2.5";

  src = fetchFromGitHub {
    owner = "Kromtec";
    repo = "LegendsViewer-Next";
    tag = "v${version}";
    hash = "sha256-R84y+QdLiEoVTo+z3jaql8m2rg2nbX9aXa2m8JiYAzU=";
  };

  patches' = patches ++ [ ./remove-npm-frontend.patch ];

  frontend = callPackage ./frontend.nix {
    inherit version src;
    patches = patches';
  };
in
buildDotnetModule rec {
  pname = "legendsviewer-next";
  inherit version src;
  patches = patches';

  strictDeps = true;
  __structuredAttrs = true;

  desktopItems = [
    (makeDesktopItem {
      name = pname;
      desktopName = "Legends Viewer";
      genericName = "DF Legends Export Browser";
      comment = meta.description;
      icon = "${frontend}/dist/ceretelina.png";
      tryExec = meta.mainProgram;
      exec = meta.mainProgram;

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

  dotnet-sdk = dotnetCorePackages.sdk_10_0;
  dotnet-runtime = dotnetCorePackages.aspnetcore_10_0;

  # File generated with `nix-build -A package.passthru.fetch-deps`
  nugetDeps = ./deps.json;

  projectFile = "./LegendsViewer.Backend/LegendsViewer.Backend.csproj";
  testProjectFile = "./LegendsViewer.Backend.Tests/LegendsViewer.Backend.Tests.csproj";
  executables = [ meta.mainProgram ];

  nativeBuildInputs = [
    copyDesktopItems
  ];

  installPhase = ''
    runHook preInstall

    lib=$out/lib/legendsviewer-next

    mkdir -p $lib

    cp ./LegendsViewer.Backend/bin/Release/*/*/* $lib
    ln -s ${frontend} $lib/legends-viewer-frontend

    runHook postInstall
  '';

  doInstallCheck = true;

  nativeInstallCheckInputs = [
    curl
  ];

  installCheckPhase = ''
    runHook preInstallCheck

    # Do not use coproc (on darwin)
    $out/bin/LegendsViewer > /dev/null 2>&1 &
    LEGENDSVIEWER_PID=$!

    # Prevent hang on darwin
    cleanup() {
      kill -KILL "$LEGENDSVIEWER_PID"
    }
    trap cleanup EXIT

    echo "Wait for server (max ~5 minutes):"
    for i in $(seq 1 300); do
      sleep 1
      if curl -fsS http://localhost:15421/api/version > /dev/null; then
        echo "Server is up!"
        break
      fi
      echo "Retrying $i / 300"
    done

    echo "Version matches expected?"
    if ! curl -fsS http://localhost:15421/api/version | grep -F "${version}"; then
      echo "Version check failed"
      exit 1
    fi

    echo "Static html server is up?"
    if ! curl -fsS http://localhost:15422 | grep "<!doctype html>"; then
      echo "Static html check failed"
      exit 1
    fi

    # Cleanup, no longer need trap
    cleanup
    trap - EXIT

    runHook postInstallCheck
  '';

  passthru = {
    updateScript = nix-update-script { };
  };

  meta = {
    description = "Recreates Dwarf Fortress' Legends Mode from exported files";
    homepage = "https://github.com/Kromtec/LegendsViewer-Next";
    license = lib.licenses.mit;
    mainProgram = "LegendsViewer";
    platforms = [
      "aarch64-darwin"
      "x86_64-darwin"
      "aarch64-linux"
      "x86_64-linux"
    ];
    maintainers = with lib.maintainers; [ donottellmetonottellyou ];
  };
}
