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
}:

buildDotnetModule rec {
  pname = "ryujinx";
  version = "1.1.91"; # Based off of the official github actions builds: https://github.com/Ryujinx/Ryujinx/actions/workflows/release.yml

  src = fetchFromGitHub {
    owner = "Ryujinx";
    repo = "Ryujinx";
    rev = "3f4fb8f73a6635dbdca9dd11738c3a793f53ac65";
    sha256 = "1amky7a2rikl5sg8y0y6il0jjqwhjgxw0d2ivynfhmhz2v2ciwwi";
  };

  dotnet-sdk = dotnetCorePackages.sdk_6_0;
  dotnet-runtime = dotnetCorePackages.runtime_6_0;

  projectFile = "Ryujinx.sln";
  nugetDeps = ./deps.nix;

  dotnetFlags = [ "/p:ExtraDefineConstants=DISABLE_UPDATER" ];

  # TODO: Add the headless frontend. Currently errors on the following:
  # System.Exception: SDL2 initlaization failed with error "No available video device"
  executables = [ "Ryujinx" ];

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
  ];

  patches = [
    ./appdir.patch # Ryujinx attempts to write to the nix store. This patch redirects it to "~/.config/Ryujinx" on Linux.
  ];

  preInstall = ''
    # workaround for https://github.com/Ryujinx/Ryujinx/issues/2349
    mkdir -p $out/lib/sndio-6
    ln -s ${sndio}/lib/libsndio.so $out/lib/sndio-6/libsndio.so.6

    # Ryujinx tries to use ffmpeg from PATH
    makeWrapperArgs+=(
      --suffix PATH : ${lib.makeBinPath [ ffmpeg ]}
    )
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
