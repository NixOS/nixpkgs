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
  nix-update-script,
}:

buildDotnetModule (finalAttrs: {
  pname = "scarab";
  version = "2.7.0.0";

  __structuredAttrs = true;
  strictDeps = true;

  src = fetchFromGitHub {
    owner = "fifty-six";
    repo = "scarab";
    tag = "v${finalAttrs.version}";
    hash = "sha256-3sztodNIB05MHA2mMPAjizRHCjiOMYFNChsmXfQJq0I=";
  };

  patches = [
    # drop on next release
    (fetchpatch2 {
      name = "fix-test-missing-shasum.patch";
      url = "https://github.com/fifty-six/Scarab/commit/581e86fefb457772d2d067f094b6dafcc49a4075.patch?full_index=1";
      hash = "sha256-N5a0QeJFQzvxX8RavwPILuLg10pWLVQhvodWpeUtItE=";
    })
  ];

  postPatch = ''
    substituteInPlace Scarab/Scarab.csproj Scarab.Tests/Scarab.Tests.csproj \
      --replace-fail '<TargetFramework>net8.0</' '<TargetFramework>net10.0</'
  '';

  dotnet-sdk = dotnetCorePackages.sdk_10_0;
  nugetDeps = ./deps.json;
  projectFile = "Scarab/Scarab.csproj";
  testProjectFile = "Scarab.Tests/Scarab.Tests.csproj";
  executables = [ "Scarab" ];

  makeWrapperArgs = [
    "--prefix"
    "PATH"
    ":"
    (lib.makeBinPath [ bc ])
    "--run"
    ". ${./scaling-settings.bash}"
  ];

  nativeBuildInputs = [
    copyDesktopItems
    icoutils
  ];

  doCheck = true;

  nativeInstallCheckInputs = [ versionCheckHook ];
  doInstallCheck = true;

  postInstall = ''
    icotool -x Scarab/Assets/omegamaggotprime.ico

    sizes=(256 128 64 48 32 16)
    for i in ''${!sizes[@]}; do
      size=''${sizes[$i]}x''${sizes[$i]}
      install -Dm644 omegamaggotprime_$((i+1))_''${size}x32.png $out/share/icons/hicolor/$size/apps/scarab.png
    done
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

  passthru.updateScript = nix-update-script { };

  meta = {
    description = "Hollow Knight mod installer and manager";
    homepage = "https://github.com/fifty-six/Scarab";
    downloadPage = "https://github.com/fifty-six/Scarab/releases";
    changelog = "https://github.com/fifty-six/Scarab/releases/tag/${finalAttrs.src.tag}";
    license = lib.licenses.gpl3Only;
    maintainers = with lib.maintainers; [
      huantian
      sigmasquadron
    ];
    mainProgram = "Scarab";
    platforms = lib.platforms.linux;
  };
})
