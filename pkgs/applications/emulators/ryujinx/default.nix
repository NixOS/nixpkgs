{ lib
, buildDotnetModule
, dotnetCorePackages
, fetchFromGitHub
, wrapGAppsHook
, libX11
, libgdiplus
, ffmpeg
, openal
, libsoundio
, sndio
, pulseaudio
, gtk3
, gdk-pixbuf
, vulkan-loader
, libICE
, libSM
, libXi
, libXcursor
, libXext
, libXrandr
, fontconfig
, glew
, libGL
, SDL2
, SDL2_mixer
}:

buildDotnetModule rec {
  pname = "ryujinx";
  version = "1.1.1102"; # Based off of the official github actions builds: https://github.com/Ryujinx/Ryujinx/actions/workflows/release.yml

  src = fetchFromGitHub {
    owner = "Ryujinx";
    repo = "Ryujinx";
    rev = "f11d663df73f68350820dfa65aa51a8a9b9ffd0f";
    sha256 = "15yai8zwwy2537ng6iqyg2jhv0q2w1c9rahkdkbvgkwiycsl7rjy";
  };

  dotnet-sdk = dotnetCorePackages.sdk_8_0;
  dotnet-runtime = dotnetCorePackages.runtime_8_0;

  nugetDeps = ./deps.nix;

  nativeBuildInputs = [
    wrapGAppsHook
  ];

  buildInputs = [
    gtk3
    gdk-pixbuf
  ];

  runtimeDeps = [
    gtk3
    libX11
    libgdiplus
    SDL2_mixer
    openal
    libsoundio
    sndio
    pulseaudio
    vulkan-loader
    ffmpeg

    # Avalonia UI
    libICE
    libSM
    libXi
    libXcursor
    libXext
    libXrandr
    fontconfig
    glew

    # Headless executable
    libGL
    SDL2
  ];

  projectFile = "Ryujinx.sln";
  testProjectFile = "src/Ryujinx.Tests/Ryujinx.Tests.csproj";
  doCheck = true;

  dotnetFlags = [
    "/p:ExtraDefineConstants=DISABLE_UPDATER%2CFORCE_EXTERNAL_BASE_DIR"
  ];

  executables = [
    "Ryujinx.Headless.SDL2"
    "Ryujinx.Ava"
    "Ryujinx"
  ];

  makeWrapperArgs = [
    # Without this Ryujinx fails to start on wayland. See https://github.com/Ryujinx/Ryujinx/issues/2714
    "--set GDK_BACKEND x11"
    "--set SDL_VIDEODRIVER x11"
  ];

  preInstall = ''
    # workaround for https://github.com/Ryujinx/Ryujinx/issues/2349
    mkdir -p $out/lib/sndio-6
    ln -s ${sndio}/lib/libsndio.so $out/lib/sndio-6/libsndio.so.6
  '';

  preFixup = ''
    mkdir -p $out/share/{applications,icons/hicolor/scalable/apps,mime/packages}
    pushd ${src}/distribution/linux

    install -D ./Ryujinx.desktop $out/share/applications/Ryujinx.desktop
    install -D ./mime/Ryujinx.xml $out/share/mime/packages/Ryujinx.xml
    install -D ../misc/Logo.svg $out/share/icons/hicolor/scalable/apps/Ryujinx.svg

    substituteInPlace $out/share/applications/Ryujinx.desktop \
      --replace "Ryujinx %f" "$out/bin/Ryujinx %f"

    ln -s $out/bin/Ryujinx $out/bin/ryujinx

    popd
  '';

  passthru.updateScript = ./updater.sh;

  meta = with lib; {
    homepage = "https://ryujinx.org/";
    changelog = "https://github.com/Ryujinx/Ryujinx/wiki/Changelog";
    description = "Experimental Nintendo Switch Emulator written in C#";
    longDescription = ''
      Ryujinx is an open-source Nintendo Switch emulator, created by gdkchan,
      written in C#. This emulator aims at providing excellent accuracy and
      performance, a user-friendly interface and consistent builds. It was
      written from scratch and development on the project began in September
      2017.
    '';
    license = licenses.mit;
    maintainers = with maintainers; [ ivar jk ];
    platforms = [ "x86_64-linux" ];
    mainProgram = "Ryujinx";
  };
}
