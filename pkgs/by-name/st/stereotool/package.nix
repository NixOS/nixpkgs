{ lib
, stdenv
, fetchurl
, autoPatchelfHook
, libX11
, libXpm
, alsa-lib
, bzip2
, zlib
, libsForQt5
, libgcc
, makeWrapper
, copyDesktopItems
, makeDesktopItem
}:

stdenv.mkDerivation rec {
  pname = "stereotool";
  version = "10.30";

  srcs =
    let
      versionNoPoint = lib.replaceStrings [ "." ] [ "" ] version;
    in
    [
      (fetchurl {
        name = "stereo-tool-icon.png";
        url = "https://download.thimeo.com/stereo_tool_icon_${versionNoPoint}.png";
        hash = "sha256-dcivH6Cc7pdQ99m80vS4E5mp/SHtTlNu1EHc+0ALIGM=";
      })
    ] ++ (
      {
        # Alsa version for 64bits.
        x86_64-linux = [
          (fetchurl {
            name = "alsa";
            url = "https://download.thimeo.com/stereo_tool_gui_64_${versionNoPoint}";
            hash = "sha256-sy1ps4knMlSKVapSQTJ6+8Q7x70/CpRUj7UkWWUkraI=";
          })
          # Jack version for 64bits.
          (fetchurl {
            name = "jack";
            url = "https://download.thimeo.com/stereo_tool_gui_jack_64_${versionNoPoint}";
            hash = "sha256-sy1ps4knMlSKVapSQTJ6+8Q7x70/CpRUj7UkWWUkraI=";
          })
          # Cmd version for 64bits
          (fetchurl {
            name = "cmd";
            url = "https://download.thimeo.com/stereo_tool_cmd_64_${versionNoPoint}";
            hash = "sha256-ncrMkuqNkdhfa1l5Ya+EMoeySDTkFshbpXVIvoJdEAc=";
          })
        ];
        # Sources if the system is aarch64-linux
        aarch64-linux = [
          (fetchurl {
            name = "alsa";
            url = "https://download.thimeo.com/stereo_tool_gui_pi2_64_${versionNoPoint}";
            hash = "sha256-o4KW7oPPUYrFLKGo/Q+ISrga9EoA7FUZUzuGtYVVT+Y=";
          })
          (fetchurl {
            name = "jack";
            url = "https://download.thimeo.com/stereo_tool_gui_jack_pi2_64_${versionNoPoint}";
            hash = "sha256-o4KW7oPPUYrFLKGo/Q+ISrga9EoA7FUZUzuGtYVVT+Y=";
          })
          (fetchurl {
            name = "cmd";
            url = "https://download.thimeo.com/stereo_tool_pi2_64_${versionNoPoint}";
            hash = "sha256-kzzPh/l+ShvdFnFqTn6CGsj8MlMxikuhi7tThD3qFEk=";
          })
        ];
        # Sources if the system is aarch32-linux
        aarch32-linux = [
          (fetchurl {
            name = "alsa";
            url = "https://download.thimeo.com/stereo_tool_gui_pi2_${versionNoPoint}";
            hash = "sha256-D5e72QabHJPaXhLa06pkS+Q/X6PiRzTn8jF2EpSf41k=";
          })
          (fetchurl {
            name = "jack";
            url = "https://download.thimeo.com/stereo_tool_gui_jack_pi2_${versionNoPoint}";
            hash = "sha256-D5e72QabHJPaXhLa06pkS+Q/X6PiRzTn8jF2EpSf41k=";
          })
          (fetchurl {
            name = "cmd";
            url = "https://download.thimeo.com/stereo_tool_pi2_${versionNoPoint}";
            hash = "sha256-RELyXszIVjsAl0qPufLbcqDTKFOTt4Hqp8CsAl56Ybo=";
          })
        ];
        # Sources if the system is 32bits i686
        i686-linux = [
          (fetchurl {
            # The name is the name of this source in the build directory
            name = "alsa";
            url = "https://download.thimeo.com/stereo_tool_gui_${versionNoPoint}";
            hash = "sha256-JSy88rTlbqIclLIg1HT+OYltve5lw8Q2fH6MIQNouUk=";
          })
          (fetchurl {
            name = "jack";
            url = "https://download.thimeo.com/stereo_tool_gui_jack_${versionNoPoint}";
            hash = "sha256-JSy88rTlbqIclLIg1HT+OYltve5lw8Q2fH6MIQNouUk=";
          })
          (fetchurl {
            name = "cmd";
            url = "https://download.thimeo.com/stereo_tool_cmd_${versionNoPoint}";
            hash = "sha256-b6v0TJaCaJKZP6uwJmmHek4y51YsK8NoslysljYHcF0=";
          })
        ];
      }.${stdenv.hostPlatform.system} or (throw "Unsupported system: ${stdenv.hostPlatform.system}"));

  unpackPhase = ''
    for srcFile in $srcs; do
      cp $srcFile $(stripHash $srcFile)
    done
  '';

  nativeBuildInputs = [
    autoPatchelfHook
    makeWrapper
    copyDesktopItems
  ];

  desktopItems = [
    (makeDesktopItem {
      name = "stereotool-alsa";
      desktopName = "Stereotool-Alsa";
      exec = "stereo_tool_gui";
      icon = "stereo-tool-icon";
      comment = "Broadcast Audio Processing";
      categories = [ "AudioVideo" "Audio" "AudioVideoEditing" ];
    })
    (makeDesktopItem {
      name = "stereotool-jack";
      desktopName = "Stereotool-Jack";
      exec = "stereo_tool_gui_jack";
      icon = "stereo-tool-icon";
      comment = "Broadcast Audio Processing";
      categories = [ "AudioVideo" "Audio" "AudioVideoEditing" ];
    })
  ];

  buildInputs = [
    libX11
    alsa-lib
    bzip2
    zlib
    libXpm
    libgcc
  ];

  installPhase = ''
    runHook preInstall
    install -Dm755 alsa $out/bin/stereo_tool_gui
    wrapProgram $out/bin/stereo_tool_gui --prefix PATH : ${lib.makeBinPath [ libsForQt5.kdialog ]}
    install -Dm755 jack $out/bin/stereo_tool_gui_jack
    wrapProgram $out/bin/stereo_tool_gui_jack --prefix PATH : ${lib.makeBinPath [ libsForQt5.kdialog ]}
    install -Dm755 cmd $out/bin/stereo_tool_cmd
    mkdir -p $out/share/icons/hicolor/48x48/apps
    cp stereo-tool-icon.png $out/share/icons/hicolor/48x48/apps/stereo-tool-icon.png
    runHook postInstall
  '';

  meta = with lib; {
    homepage = "https://www.thimeo.com/stereo-tool/";
    description = "Stereo Tool is a software-based audio processor which offers outstanding audio quality and comes with many unique features";
    license = licenses.unfree;
    mainProgram = "stereo_tool_gui";
    platforms = [ "aarch64-linux" "aarch32-linux" "x86_64-linux" "i686-linux" ];
    maintainers = with maintainers; [ RudiOnTheAir ];
  };

}
