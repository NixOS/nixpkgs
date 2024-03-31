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
  version = "10.21";

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
            hash = "sha256-ByRguhZ29ertQM3q+TPUUT1BMnAJGbwNe8WbNxLhcmk=";
          })
          # Jack version for 64bits.
          (fetchurl {
            name = "jack";
            url = "https://download.thimeo.com/stereo_tool_gui_jack_64_${versionNoPoint}";
            hash = "sha256-ByRguhZ29ertQM3q+TPUUT1BMnAJGbwNe8WbNxLhcmk=";
          })
          # Cmd version for 64bits
          (fetchurl {
            name = "cmd";
            url = "https://download.thimeo.com/stereo_tool_cmd_64_${versionNoPoint}";
            hash = "sha256-PGheJfOQJzI1gs05qW9vcAMoVnCPIHR2qS0GIg5V6vw=";
          })
        ];
        # Sources if the system is aarch64-linux
        aarch64-linux = [
          (fetchurl {
            name = "alsa";
            url = "https://download.thimeo.com/stereo_tool_gui_pi2_64_${versionNoPoint}";
            hash = "sha256-iwoc6c+ox+2DSqmiz8mpDotDjqki7iL0jgqc7Z1htNI=";
          })
          (fetchurl {
            name = "jack";
            url = "https://download.thimeo.com/stereo_tool_gui_jack_pi2_64_${versionNoPoint}";
            hash = "sha256-iwoc6c+ox+2DSqmiz8mpDotDjqki7iL0jgqc7Z1htNI==";
          })
          (fetchurl {
            name = "cmd";
            url = "https://download.thimeo.com/stereo_tool_pi2_64_${versionNoPoint}";
            hash = "sha256-bIFnQkJB9XoEKo7IG+MSMvx/ia1C8i97Cw7EX4EDizk=";
          })
        ];
        # Sources if the system is aarch32-linux
        aarch32-linux = [
          (fetchurl {
            name = "alsa";
            url = "https://download.thimeo.com/stereo_tool_gui_pi2_${versionNoPoint}";
            hash = "sha256-922yqmis5acvASU2rEi5YzFLAUuDO7BiEiW49RKfcoU=";
          })
          (fetchurl {
            name = "jack";
            url = "https://download.thimeo.com/stereo_tool_gui_jack_pi2_${versionNoPoint}";
            hash = "sha256-922yqmis5acvASU2rEi5YzFLAUuDO7BiEiW49RKfcoU=";
          })
          (fetchurl {
            name = "cmd";
            url = "https://download.thimeo.com/stereo_tool_pi2_${versionNoPoint}";
            hash = "sha256-xKM5Mg6gEAvbp63rd81ssnx2Bj1hUylCo36mQBYwIvg=";
          })
        ];
        # Sources if the system is 32bits i686
        i686-linux = [
          (fetchurl {
            # The name is the name of this source in the build directory
            name = "alsa";
            url = "https://download.thimeo.com/stereo_tool_gui_${versionNoPoint}";
            hash = "sha256-iEPqJvmXKXD4AVbM+1QZeUOwpMjMT7ROYNQpmhRVZyw=";
          })
          (fetchurl {
            name = "jack";
            url = "https://download.thimeo.com/stereo_tool_gui_jack_${versionNoPoint}";
            hash = "sha256-iEPqJvmXKXD4AVbM+1QZeUOwpMjMT7ROYNQpmhRVZyw=";
          })
          (fetchurl {
            name = "cmd";
            url = "https://download.thimeo.com/stereo_tool_cmd_${versionNoPoint}";
            hash = "sha256-sk13wj7XvuwTDWWW6tMYHdTV9XjPeHe6hHv2JPBxBLA=";
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
    description = "Stereo Tool is a software-based audio processor which offers outstanding audio quality and comes with many unique features.";
    license = licenses.unfree;
    mainProgram = "stereo_tool_gui";
    platforms = [ "aarch64-linux" "aarch32-linux" "x86_64-linux" "i686-linux" ];
    maintainers = with maintainers; [ RudiOnTheAir ];
  };

}
