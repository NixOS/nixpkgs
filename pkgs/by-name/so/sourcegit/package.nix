{
  lib,
  buildDotnetModule,
  fetchFromGitHub,
  dotnetCorePackages,
  copyDesktopItems,
  makeDesktopItem,
  libicns,

  git,
  xdg-utils,
}:

let
  binPath = lib.makeBinPath [
    git
    xdg-utils
  ];
in

buildDotnetModule rec {
  pname = "sourcegit";
  version = "8.30.1";

  src = fetchFromGitHub {
    owner = "sourcegit-scm";
    repo = "sourcegit";
    rev = "refs/tags/v${version}";
    hash = "sha256-HlyCOumeB3Vc4p+92YM1JrqW1d4p8+cRwKyHbpjVD4w=";
  };

  patches = [ ./fix-darwin-git-path.patch ];

  dotnet-sdk = dotnetCorePackages.sdk_8_0;
  dotnet-runtime = dotnetCorePackages.runtime_8_0;

  nugetDeps = ./deps.nix;

  projectFile = [ "src/SourceGit.csproj" ];

  executables = [ "SourceGit" ];

  dotnetFlags = [
    "-p:PublishAot=false" # untill https://github.com/NixOS/nixpkgs/issues/280923 is fixed
  ];

  nativeBuildInputs = [
    copyDesktopItems
    libicns
  ];

  desktopItems = [
    (makeDesktopItem {
      name = "SourceGit";
      exec = "SourceGit";
      icon = "SourceGit";
      desktopName = "SourceGit";
      terminal = false;
      comment = meta.description;
    })
  ];

  preInstall = ''
    makeWrapperArgs+=(
      --suffix PATH : ${binPath}
    )
  '';

  postInstall = ''
    icns2png -x build/resources/App.icns
    for f in App_*x32.png; do
        res=''${f//App_}
        res=''${res//x32.png}
        install -Dm644 $f "$out/share/icons/hicolor/$res/apps/SourceGit.png"
    done
  '';

  meta = {
    changelog = "https://github.com/sourcegit-scm/sourcegit/releases/tag/${version}";
    description = "Free & OpenSource GUI client for GIT users";
    homepage = "https://github.com/sourcegit-scm/sourcegit";
    license = lib.licenses.mit;
    mainProgram = "SourceGit";
    maintainers = with lib.maintainers; [ tomasajt ];
  };
}
