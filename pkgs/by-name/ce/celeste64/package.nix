{
  lib,
  buildDotnetModule,
  dotnetCorePackages,
  fetchFromGitHub,
  makeDesktopItem,
  copyDesktopItems,
  SDL2,
  libGL,
  systemd,
  libpulseaudio,
  libselinux,
  wayland,
  libdecor,
  xorg,
  libxkbcommon,
  libdrm,
  withSELinux ? false,
}:

buildDotnetModule rec {
  pname = "celeste64";
  version = "1.1.1";

  src = fetchFromGitHub {
    repo = "Celeste64";
    owner = "ExOK";
    rev = "v${version}";
    hash = "sha256-XRAjDYIqYaQYCWNNT7UuLDKDBgq3vqxtCzay7pGICtA=";
  };
  projectFile = "Celeste64.csproj";
  dotnet-sdk = dotnetCorePackages.sdk_8_0;
  dotnet-runtime = dotnetCorePackages.runtime_8_0;
  nugetDeps = ./deps.nix;
  strictDeps = true;
  executables = [ "Celeste64" ];
  nativeBuildInputs = [ copyDesktopItems ];
  runtimeDeps =
    [
      libdecor
      libGL
      SDL2
      systemd
      libpulseaudio
      wayland
      libdrm
      libxkbcommon
      xorg.libX11
      xorg.libXfixes
      xorg.libXext
      xorg.libXcursor
      xorg.libXi
      xorg.libXrandr
    ]
    ++ lib.optionals withSELinux [ libselinux ];

  postInstall = ''
    export ICON_DIR=$out/share/icons/hicolor/256x256/apps
    mkdir -p $ICON_DIR

    cp -r $src/Content $out/lib/$pname/
    cp $src/Content/Models/Sources/logo1.png $ICON_DIR/Celeste64.png
  '';


  desktopItems = [
    (makeDesktopItem {
      name = "Celeste64";
      exec = "Celeste64";
      comment = meta.description;
      desktopName = "Celeste64";
      genericName = "Celeste64";
      icon = "Celeste64";
      categories = [ "Game" ];
    })
  ];

  meta = {
    license = with lib.licenses; [ unfree mit ];
    platforms = [ "x86_64-linux" "aarch64-linux" "armv7l-linux" ];
    maintainers = with lib.maintainers; [ ];
    mainProgram = "Celeste64";
    homepage = "https://github.com/ExOK/Celeste64";
    description = "Celeste 64: Fragments of the Mountain";
    downloadPage = "https://maddymakesgamesinc.itch.io/celeste64";
  };
}
