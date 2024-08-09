{
  lib,
  stdenv,
  fetchFromGitHub,
  xcbuild,
  swift,
  swiftPackages,
  nix-update-script,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "stats";
  version = "2.11.5";

  src = fetchFromGitHub {
    owner = "exelban";
    repo = "Stats";
    rev = "v${finalAttrs.version}";
    sha256 = "sha256-SLI0qcSfDHQj6tsKXF1RSwYWZxAQurgw7AYGV009aRQ=";
  };

  nativeBuildInputs = [
    xcbuild
    swiftPackages.swift-docc
  ];

  buildPhase = ''
    runHook preBuild

    export SWIFT_LIBRARY_PATH=${swift.swift.lib}/${swift.swiftModuleSubdir}

    xcodebuild \
      -scheme Stats \
      -destination 'platform=macOS' \
      -configuration Release build CODE_SIGNING_ALLOWED=NO \
      -derivedDataPath "$(pwd)/build"

    mkdir -p "$out/Applications"
    cp -R "./build/Build/Products/Release/Stats.app" "$out/Applications/Stats.app"

    runHook postBuild
  '';

  patches = [ ./0001-Fixup-MARKETING_VERSION.patch ];

  passthru.updateScript = nix-update-script { };

  meta = {
    description = "macOS system monitor in your menu bar";
    homepage = "https://github.com/exelban/Stats";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [
      donteatoreo
      emilytrau
    ];
    platforms = lib.platforms.darwin;
  };
})
