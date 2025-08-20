{
  lib,
  clangStdenv,
  buildDotnetModule,
  dotnetCorePackages,
  fetchFromGitHub,
  wrapGAppsHook3,
  gtk3,
  SDL2,
}:

buildDotnetModule rec {
  pname = "mesen";
  version = "2.0.0-unstable-2024-12-25";

  src = fetchFromGitHub {
    owner = "SourMesen";
    repo = "Mesen2";
    rev = "6820db37933002089a04d356d8469481e915a359";
    hash = "sha256-TzGMZr351XvVj/wARWJxRisRb5JlkyzdjCVYbwydBVE=";
  };

  patches = [
    # the nightly avalonia repository url is still queried, which errors out
    # even if we don't actually need any nightly versions
    ./dont-use-alternative-restore-sources.patch
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

    buildInputs = [ SDL2 ];

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
