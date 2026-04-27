{
  lib,
  stdenv,
  fetchFromGitHub,
  apple-sdk,
  darwin,
  xcbuildHook,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "caffeine";
  version = "1.1.4";

  src = fetchFromGitHub {
    owner = "IntelliScape";
    repo = "caffeine";
    tag = finalAttrs.version;
    hash = "sha256-AmBPY5ZVWBq2ZesNvvJ/Do5XgPjb5R1ESNJm7tx0M6k=";
  };

  # xcbuild routes image.png resources through CopyPNGFile, which requires the
  # Apple-only copypng tool that is unavailable in the nixpkgs toolchain.
  # Treat these PNGs as generic files so xcbuild copies them directly.
  postPatch = ''
    substituteInPlace Caffeine.xcodeproj/project.pbxproj \
      --replace-fail \
        "lastKnownFileType = image.png;" \
        "lastKnownFileType = file;"
  '';

  nativeBuildInputs = [
    xcbuildHook
    darwin.autoSignDarwinBinariesHook
  ];

  buildInputs = [
    apple-sdk
  ];

  xcbuildFlags = [
    "-target Caffeine"
    "-configuration Release"
  ];

  installPhase = ''
    runHook preInstall

    mkdir -p $out/Applications
    cp -r Products/Release/Caffeine.app $out/Applications

    runHook postInstall
  '';

  meta = {
    description = "Don't let your Mac fall asleep";
    homepage = "https://intelliscapesolutions.com/apps/caffeine";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ emilytrau ];
    platforms = [
      "x86_64-darwin"
      "aarch64-darwin"
    ];
  };
})
