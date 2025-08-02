{
  swiftPackages,
  fetchFromGitHub,
  swift,
  swiftpm,
  lib,
}:

swiftPackages.stdenv.mkDerivation (finalAttrs: {
  pname = "desktoppr";
  version = "0.5";

  src = fetchFromGitHub {
    owner = "scriptingosx";
    repo = "desktoppr";
    tag = "v${finalAttrs.version}";
    hash = "sha256-eEVcYSa1ntyX/Wdj4HUyXyXIrK+T11Thg23ntNoIgH0=";
  };

  patches = [
    ./0001-updated-version-in-code-as-well.patch
    ./0002-Add-support-for-building-with-Swift-Package-Manager.patch
  ];

  nativeBuildInputs = [
    swift
    swiftpm
  ];

  installPhase = ''
    runHook preInstall
    install -Dm755 $(swiftpmBinPath)/desktoppr -t $out/bin
    runHook postInstall
  '';

  meta = {
    description = "Simple command line tool to read and set the desktop picture/wallpaper";
    homepage = "https://github.com/scriptingosx/desktoppr";
    platforms = lib.platforms.darwin;
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [ andre4ik3 ];
    mainProgram = "desktoppr";
  };
})
