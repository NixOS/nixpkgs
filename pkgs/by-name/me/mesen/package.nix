{
  lib,
  clangStdenv,
  buildDotnetModule,
  dotnetCorePackages,
  fetchFromGitHub,
  wrapGAppsHook3,
  gtk3,
  libX11,
  SDL2,
}:

buildDotnetModule rec {
  pname = "mesen";
  version = "2.0.0-unstable-2025-04-01";

  src = fetchFromGitHub {
    owner = "SourMesen";
    repo = "Mesen2";
    rev = "0dfdbbdd9b5bc4c5d501ea691116019266651aff";
    hash = "sha256-+Jzw1tfdiX2EmQIoPuMtLmJrv9nx/XqfyLEBW+AXj1I=";
  };

  patches = [
    # patch out the usage of nightly avalonia builds, since we can't use alternative restore sources
    ./dont-use-nightly-avalonia.patch
    # upstream has a weird library loading mechanism, which we override with a more sane alternative
    ./dont-zip-libraries.patch
  ];

  dotnet-sdk = dotnetCorePackages.sdk_8_0;
  dotnet-runtime = dotnetCorePackages.runtime_8_0;

  projectFile = [ "UI/UI.csproj" ];

  dotnetFlags = [
    "-p:RuntimeIdentifier=${dotnetCorePackages.systemToDotnetRid clangStdenv.hostPlatform.system}"
  ];

  executables = [ "Mesen" ];

  nugetDeps = ./deps.json;

  nativeBuildInputs = [ wrapGAppsHook3 ];

  runtimeDeps = [ gtk3 ];

  postInstall = ''
    ln -s ${passthru.core}/lib/MesenCore.* $out/lib/mesen
  '';

  # according to upstream, compiling with clang creates a faster binary
  passthru.core = clangStdenv.mkDerivation {
    pname = "mesen-core";
    inherit version src;

    enableParallelBuilding = true;

    strictDeps = true;

    nativeBuildInputs = [ SDL2 ];

    buildInputs = [ SDL2 ] ++ lib.optionals clangStdenv.hostPlatform.isLinux [ libX11 ];

    makeFlags = [ "core" ];

    installPhase = ''
      runHook preInstall
      install -Dm755 InteropDLL/obj.*/MesenCore.* -t $out/lib
      runHook postInstall
    '';
  };

  meta = {
    badPlatforms = [ "aarch64-linux" ]; # not sure what the issue is
    description = "Multi-system emulator that supports NES, SNES, Game Boy (Color) and PC Engine games";
    homepage = "https://www.mesen.ca";
    license = lib.licenses.gpl3Plus;
    mainProgram = "Mesen";
    maintainers = with lib.maintainers; [ tomasajt ];
  };
}
