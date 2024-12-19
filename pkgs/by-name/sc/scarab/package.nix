{
  lib,
  bc,
  buildDotnetModule,
  fetchFromGitHub,
  copyDesktopItems,
  icoutils,
  makeDesktopItem,
  dotnetCorePackages,
}:

buildDotnetModule rec {
  pname = "scarab";
  version = "2.6.0.0";

  src = fetchFromGitHub {
    owner = "fifty-six";
    repo = "scarab";
    rev = "refs/tags/v${version}";
    hash = "sha256-xnvS3FDY4hi3yauwoSzO1fO6tJJAwFCkAc0Wzfs/puQ=";
  };

  dotnet-sdk = dotnetCorePackages.sdk_8_0;
  nugetDeps = ./deps.json;
  projectFile = "Scarab/Scarab.csproj";
  testProjectFile = "Scarab.Tests/Scarab.Tests.csproj";
  executables = [ "Scarab" ];

  runtimeDeps = [
    bc
  ];

  nativeBuildInputs = [
    copyDesktopItems
    icoutils
  ];

  doCheck = true;

  postFixup = ''
    # Icons for the desktop file
    icotool -x $src/Scarab/Assets/omegamaggotprime.ico

    sizes=(256 128 64 48 32 16)
    for i in ''${!sizes[@]}; do
      size=''${sizes[$i]}x''${sizes[$i]}
      install -D omegamaggotprime_''$((i+1))_''${size}x32.png $out/share/icons/hicolor/$size/apps/scarab.png
    done

    wrapProgram "$out/bin/Scarab" --run '. ${./scaling-settings.bash}'
  '';

  desktopItems = [
    (makeDesktopItem {
      desktopName = "Scarab";
      name = "scarab";
      exec = "Scarab";
      icon = "scarab";
      comment = "Hollow Knight mod installer and manager";
      type = "Application";
      categories = [ "Game" ];
    })
  ];

  passthru.updateScript = ./update.sh;

  meta = {
    description = "Hollow Knight mod installer and manager";
    homepage = "https://github.com/fifty-six/Scarab";
    downloadPage = "https://github.com/fifty-six/Scarab/releases";
    changelog = "https://github.com/fifty-six/Scarab/releases/tag/v${version}";
    license = lib.licenses.gpl3Only;
    maintainers = with lib.maintainers; [
      huantian
      sigmasquadron
    ];
    mainProgram = "Scarab";
    platforms = lib.platforms.linux;
  };
}
