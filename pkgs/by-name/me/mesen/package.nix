{
  lib,
  clangStdenv,
  buildDotnetModule,
  dotnetCorePackages,
  fetchFromGitHub,
  fetchpatch,
  wrapGAppsHook3,
  gtk3,
  SDL2,
  darwin,
}:

buildDotnetModule rec {
  pname = "mesen";
  version = "2.0.0-unstable-2024-09-15";

  src = fetchFromGitHub {
    owner = "SourMesen";
    repo = "Mesen2";
    rev = "aa1c20afe578aa2b0cceaf13e3168ac1309d46f6";
    hash = "sha256-hioW2bdra/XgFhRLbOxLwMEJbQiaijo0Rx8E0f/pDhQ=";
  };

  patches = [
    (fetchpatch {
      name = "dont-use-nightly-avalonia.patch";
      url = "https://github.com/SourMesen/Mesen2/commit/d4501b7954af97039211367e9a6c2dacf3d93c6b.patch";
      revert = true;
      hash = "sha256-9sCQbqxDsqC89RZg0lfoZ/gtSTjVv/xKFwaVghjvvE0=";
    })
    ./dont-zip-libraries.patch
  ];

  dotnet-sdk = dotnetCorePackages.sdk_8_0;
  dotnet-runtime = dotnetCorePackages.runtime_8_0;

  projectFile = [ "UI/UI.csproj" ];

  executables = [ "Mesen" ];

  nugetDeps = ./deps.nix;

  nativeBuildInputs = [ wrapGAppsHook3 ];

  runtimeDeps = [ gtk3 ];

  postInstall = ''
    ln -s ${passthru.core}/lib/MesenCore.* $out/lib/mesen
  '';

  # according to upstream, compiling with clang creates a faster binary
  passthru.core = clangStdenv.mkDerivation {
    pname = "mesen-core";
    inherit version src;

    buildInputs =
      [ SDL2 ]
      ++ lib.optionals clangStdenv.isDarwin [
        darwin.apple_sdk.frameworks.Cocoa
        darwin.apple_sdk.frameworks.Foundation
      ];

    makeFlags = [ "core" ];

    installPhase = ''
      runHook preInstall
      install -Dm755 InteropDLL/obj.*/MesenCore.* -t $out/lib
      runHook postInstall
    '';
  };

  meta = {
    description = "Multi-system emulator that supports NES, SNES, Game Boy (Color) and PC Engine games";
    homepage = "https://www.mesen.ca";
    license = lib.licenses.gpl3Plus;
    mainProgram = "Mesen";
    maintainers = with lib.maintainers; [ tomasajt ];
  };
}
