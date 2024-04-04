{
  lib,
  clangStdenv,
  buildDotnetModule,
  dotnetCorePackages,
  wrapGAppsHook3,
  fetchFromGitHub,
  gtk3,
  libX11,
  libICE,
  libSM,
  libXi,
  libXcursor,
  libXext,
  libXrandr,
  fontconfig,
  glew,
  SDL2,
}:

buildDotnetModule rec {
  pname = "mesen";
  version = "2.0.0-unstable-2024-06-01";

  src = fetchFromGitHub {
    owner = "SourMesen";
    repo = "Mesen2";
    rev = "f5959beb3e7be0cad649e1febe053fe017837fea";
    hash = "sha256-cgJiJ7kr/bXJfD07h5xXgGz+ClRi9w3txBvFYxeFFkI=";
  };

  patches = [
    ./dont-use-nightly-avalonia.patch
    ./dont-zip-libraries.patch
  ];

  dotnet-sdk = dotnetCorePackages.sdk_8_0;
  dotnet-runtime = dotnetCorePackages.runtime_8_0;

  projectFile = [ "UI/UI.csproj" ];

  executables = [ "Mesen" ];

  nugetDeps = ./deps.nix;

  nativeBuildInputs = [ wrapGAppsHook3 ];

  runtimeDeps = [
    gtk3
    # Avalonia deps
    libX11
    libICE
    libSM
    libXi
    libXcursor
    libXext
    libXrandr
    fontconfig
    glew
  ];

  # according to upstream, compiling with clang creates a faster binary
  core = clangStdenv.mkDerivation {
    pname = "mesen-core";
    inherit version src;

    buildInputs = [ SDL2 ];

    makeFlags = [ "core" ];

    installPhase = ''
      runHook preInstall
      install -Dm755 InteropDLL/obj.*/MesenCore.* -t $out/lib
      runHook postInstall
    '';
  };

  postInstall = ''
    ln -s ${core}/lib/MesenCore.* $out/lib/mesen
  '';

  meta = {
    description = "A multi-system emulator that supports NES, SNES, Game Boy (Color) and PC Engine games";
    homepage = "https://www.mesen.ca";
    license = lib.licenses.gpl3Plus;
    mainProgram = "Mesen";
    maintainers = with lib.maintainers; [ tomasajt ];
  };
}
