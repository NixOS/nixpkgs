{ lib
, buildDotnetModule
, fetchFromGitHub
, dotnetCorePackages
, libX11
, libgdiplus
, ffmpeg
, SDL2_mixer
, openal
, libsoundio
, sndio
, pulseaudio
, gtk3
, gdk-pixbuf
, wrapGAppsHook
, vulkan-loader
, libICE
, libSM
, libXi
, libXcursor
, libXext
, libXrandr
, fontconfig
, glew
}:

buildDotnetModule rec {
  pname = "ryujinx";
  version = "1.1.223"; # Based off of the official github actions builds: https://github.com/Ryujinx/Ryujinx/actions/workflows/release.yml

  src = fetchFromGitHub {
    owner = "Ryujinx";
    repo = "Ryujinx";
    rev = "951700fdd8f54fb34ffe8a3fb328a68b5bf37abe";
    sha256 = "0kzchsxir8wh74rxvp582mci855hbd0vma6yhcc9vpz0zmhi2cpf";
  };

  projectFile = "Ryujinx.sln";
  nugetDeps = ./deps.nix;

  dotnetFlags = [ "/p:ExtraDefineConstants=DISABLE_UPDATER" ];

  # TODO: Add the headless frontend. Currently errors on the following:
  # System.Exception: SDL2 initlaization failed with error "No available video device"
  executables = [ "Ryujinx" "Ryujinx.Ava" ];

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
  ];

  patches = [
    ./appdir.patch # Ryujinx attempts to write to the nix store. This patch redirects it to "~/.config/Ryujinx" on Linux.
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

    install -D ./ryujinx.desktop $out/share/applications/ryujinx.desktop
    install -D ./ryujinx-mime.xml $out/share/mime/packages/ryujinx-mime.xml
    install -D ./ryujinx-logo.svg $out/share/icons/hicolor/scalable/apps/ryujinx.svg

    substituteInPlace $out/share/applications/ryujinx.desktop --replace \
      "Exec=Ryujinx" "Exec=$out/bin/Ryujinx"

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
