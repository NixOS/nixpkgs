{
  lib,
  buildDotnetModule,
  fetchFromGitHub,
  fetchpatch2,
  dotnetCorePackages,
  bc,
  copyDesktopItems,
  icoutils,
  versionCheckHook,
  makeDesktopItem,
}:

buildDotnetModule rec {
  pname = "scarab";
  version = "2.7.0.0";

  src = fetchFromGitHub {
    owner = "fifty-six";
    repo = "scarab";
    tag = "v${version}";
    hash = "sha256-3sztodNIB05MHA2mMPAjizRHCjiOMYFNChsmXfQJq0I=";
  };

  patches = [
    (fetchpatch2 {
      name = "fix-test-missing-shasum.patch";
      url = "https://github.com/fifty-six/Scarab/commit/581e86fefb457772d2d067f094b6dafcc49a4075.patch?full_index=1";
      hash = "sha256-N5a0QeJFQzvxX8RavwPILuLg10pWLVQhvodWpeUtItE=";
    })
  ];

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

  nativeInstallCheckInputs = [ versionCheckHook ];
  doInstallCheck = true;

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
