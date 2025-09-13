{
  lib,
  stdenv,
  buildDotnetModule,
  fetchFromGitHub,
  dotnetCorePackages,
  copyDesktopItems,
  makeDesktopItem,
  libicns,

  libXcursor,
  libXext,
  libXi,
  libXrandr,

  git,
  xdg-utils,

  nix-update-script,
}:

buildDotnetModule (finalAttrs: {
  pname = "sourcegit";
  version = "2025.34";

  src = fetchFromGitHub {
    owner = "sourcegit-scm";
    repo = "sourcegit";
    tag = "v${finalAttrs.version}";
    hash = "sha256-O7HzbrcQGgP3mRSfqLxoHPswVW99S9chb7ZWBeEelsY=";
  };

  patches = [ ./fix-darwin-git-path.patch ];

  dotnet-sdk = dotnetCorePackages.sdk_9_0;
  dotnet-runtime = dotnetCorePackages.runtime_9_0;

  nugetDeps = ./deps.json;

  projectFile = [ "src/SourceGit.csproj" ];

  executables = [ "SourceGit" ];

  dotnetFlags = [
    "-p:DisableUpdateDetection=true"
    "-p:DisableAOT=true"
  ];

  nativeBuildInputs = lib.optionals stdenv.hostPlatform.isLinux [
    copyDesktopItems
    libicns
  ];

  # these are dlopen-ed at runtime
  # libXi is needed for right-click support
  # not sure about what the other ones are needed for, but I'll include them anyways
  runtimeDeps = [
    libXcursor
    libXext
    libXi
    libXrandr
  ];

  # Note: users can use `.overrideAttrs` to append to this list
  runtimePathDeps = [
    git
    xdg-utils
  ];

  # add fallback binaries to use if the user doesn't already have them in their PATH
  preInstall = ''
    makeWrapperArgs+=(
      --suffix PATH : ${lib.makeBinPath finalAttrs.runtimePathDeps}
    )
  '';

  desktopItems = [
    (makeDesktopItem {
      name = "SourceGit";
      exec = "SourceGit";
      icon = "SourceGit";
      desktopName = "SourceGit";
      terminal = false;
      comment = finalAttrs.meta.description;
    })
  ];

  postInstall =
    lib.optionalString stdenv.hostPlatform.isLinux ''
      # extract the .icns file into multiple .png files
      # where the format of the .png file names is App_"$n"x"$n"x32.png

      icns2png -x build/resources/app/App.icns

      for f in App_*x32.png; do
        res=''${f//App_}
        res=''${res//x32.png}
        install -Dm644 $f "$out/share/icons/hicolor/$res/apps/SourceGit.png"
      done
    ''
    + lib.optionalString stdenv.hostPlatform.isDarwin ''
      install -Dm644 build/resources/app/App.icns $out/Applications/SourceGit.app/Contents/Resources/App.icns

      substitute build/resources/app/App.plist $out/Applications/SourceGit.app/Contents/Info.plist \
        --replace-fail "SOURCE_GIT_VERSION" "${finalAttrs.version}"

      mkdir -p $out/Applications/SourceGit.app/Contents/MacOS
      ln -s $out/bin/SourceGit $out/Applications/SourceGit.app/Contents/MacOS/SourceGit
    '';

  passthru.updateScript = nix-update-script { };

  meta = {
    changelog = "https://github.com/sourcegit-scm/sourcegit/releases/tag/${finalAttrs.src.tag}";
    description = "Free & OpenSource GUI client for GIT users";
    homepage = "https://github.com/sourcegit-scm/sourcegit";
    license = lib.licenses.mit;
    mainProgram = "SourceGit";
    maintainers = with lib.maintainers; [ tomasajt ];
  };
})
