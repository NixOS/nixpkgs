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
  version = "2.1.1";

  src = fetchFromGitHub {
    owner = "SourMesen";
    repo = "Mesen2";
    tag = version;
    hash = "sha256-vBwAPAnp6HIgI49vAZIqnzw8xHQ7ZMuALjf7G+acCXg=";
  };

  patches = [
    # patch out the usage of nightly avalonia builds, since we can't use alternative restore sources
    ./dont-use-nightly-avalonia.patch
    # upstream has a weird library loading mechanism, which we override with a more sane alternative
    ./dont-zip-libraries.patch
    # without this the generated .desktop file uses an absolute (and incorrect) path for the binary
    ./desktop-make-non-absolute-exec.patch
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
    description = "Multi-system emulator that supports NES, SNES, Game Boy, Game Boy Advance, PC Engine, SMS/Game Gear and WonderSwan games";
    homepage = "https://www.mesen.ca";
    license = lib.licenses.gpl3Plus;
    mainProgram = "Mesen";
    maintainers = with lib.maintainers; [ tomasajt ];
  };
}
