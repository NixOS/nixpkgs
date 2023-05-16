{ lib
, buildDotnetModule
, dotnetCorePackages
<<<<<<< HEAD
=======
, stdenvNoCC
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
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
<<<<<<< HEAD
  version = "1.1.999"; # Based off of the official github actions builds: https://github.com/Ryujinx/Ryujinx/actions/workflows/release.yml
=======
  version = "1.1.733"; # Based off of the official github actions builds: https://github.com/Ryujinx/Ryujinx/actions/workflows/release.yml
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)

  src = fetchFromGitHub {
    owner = "Ryujinx";
    repo = "Ryujinx";
<<<<<<< HEAD
    rev = "7f96dbc0242f169caeb8461237bc01a23c115f56";
    sha256 = "1fi1bfbz07k9n8civ7gv0rlksdm59wpjcq50hrj7dgwnkrlmxdi2";
=======
    rev = "9f12e50a546b15533778ed0d8290202af91c10a2";
    sha256 = "1d1hg2sv0h56a56xnarcfp73df3rbw3iax85g258l6w2kxhkc42a";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
  };

  dotnet-sdk = dotnetCorePackages.sdk_7_0;
  dotnet-runtime = dotnetCorePackages.runtime_7_0;

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
<<<<<<< HEAD
  testProjectFile = "src/Ryujinx.Tests/Ryujinx.Tests.csproj";
=======
  testProjectFile = "Ryujinx.Tests/Ryujinx.Tests.csproj";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
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
<<<<<<< HEAD
      --replace "Ryujinx %f" "$out/bin/Ryujinx %f"
=======
      --replace "Exec=Ryujinx" "Exec=$out/bin/Ryujinx"
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)

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
