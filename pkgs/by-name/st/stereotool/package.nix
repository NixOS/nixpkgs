{
  lib,
  stdenv,
  fetchurl,
  autoPatchelfHook,
  libx11,
  libxpm,
  alsa-lib,
  bzip2,
  zlib,
  kdePackages,
  libgcc,
  makeWrapper,
  copyDesktopItems,
  makeDesktopItem,
}:

stdenv.mkDerivation rec {
  pname = "stereotool";
  version = "10.71";

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
    ]
    ++ (
      {
        # Alsa version for 64bits.
        x86_64-linux = [
          (fetchurl {
            name = "alsa";
            url = "https://download.thimeo.com/stereo_tool_gui_64_${versionNoPoint}";
            hash = "sha256-YDrB7MX2EbG9Eknx5XlOAaW/2sPTZzPIGXzFcwKGqK8=";
          })
          # Jack version for 64bits.
          (fetchurl {
            name = "jack";
            url = "https://download.thimeo.com/stereo_tool_gui_jack_64_${versionNoPoint}";
            hash = "sha256-YDrB7MX2EbG9Eknx5XlOAaW/2sPTZzPIGXzFcwKGqK8=";
          })
          # Cmd version for 64bits
          (fetchurl {
            name = "cmd";
            url = "https://download.thimeo.com/stereo_tool_cmd_64_${versionNoPoint}";
            hash = "sha256-+hm8G5jwgFqDzy7BsYSfJh3x9asx7voc4NdIqkBDGmE=";
          })
        ];
        # Sources if the system is aarch64-linux
        aarch64-linux = [
          (fetchurl {
            name = "alsa";
            url = "https://download.thimeo.com/stereo_tool_gui_pi2_64_${versionNoPoint}";
            hash = "sha256-nr3VlRpWELe4vlaKenPa3ZtOHjD66BXbGDd2WjTI70E=";
          })
          (fetchurl {
            name = "jack";
            url = "https://download.thimeo.com/stereo_tool_gui_jack_pi2_64_${versionNoPoint}";
            hash = "sha256-nr3VlRpWELe4vlaKenPa3ZtOHjD66BXbGDd2WjTI70E=";
          })
          (fetchurl {
            name = "cmd";
            url = "https://download.thimeo.com/stereo_tool_pi2_64_${versionNoPoint}";
            hash = "sha256-QyJ/BulqWEIpGfbd6qGT4ejOtdVJ0/M2pEvJasRZUNE=";
          })
        ];
        # Sources if the system is aarch32-linux
        aarch32-linux = [
          (fetchurl {
            name = "alsa";
            url = "https://download.thimeo.com/stereo_tool_gui_pi2_${versionNoPoint}";
            hash = "sha256-ryw4m08Ru2GI/Wq0UZwjmect7OAHaftfy+0J1S1bYh8=";
          })
          (fetchurl {
            name = "jack";
            url = "https://download.thimeo.com/stereo_tool_gui_jack_pi2_${versionNoPoint}";
            hash = "sha256-ryw4m08Ru2GI/Wq0UZwjmect7OAHaftfy+0J1S1bYh8=";
          })
          (fetchurl {
            name = "cmd";
            url = "https://download.thimeo.com/stereo_tool_pi2_${versionNoPoint}";
            hash = "sha256-l9VWraDHJXfNJVb8/VvHENvdknT6ccPBmt/mGlwND00=";
          })
        ];
        # Sources if the system is 32bits i686
        i686-linux = [
          (fetchurl {
            # The name is the name of this source in the build directory
            name = "alsa";
            url = "https://download.thimeo.com/stereo_tool_gui_${versionNoPoint}";
            hash = "sha256-OnGn/OUkXFZ4SnmibpF/0kxeq8YZIWMMVafy6i96GeA=";
          })
          (fetchurl {
            name = "jack";
            url = "https://download.thimeo.com/stereo_tool_gui_jack_${versionNoPoint}";
            hash = "sha256-OnGn/OUkXFZ4SnmibpF/0kxeq8YZIWMMVafy6i96GeA=";
          })
          (fetchurl {
            name = "cmd";
            url = "https://download.thimeo.com/stereo_tool_cmd_${versionNoPoint}";
            hash = "sha256-GDpfSeL14XkvroIF6pm5CzNYiEz/v5uzfyjw+7K1idE=";
          })
        ];
      }
      .${stdenv.hostPlatform.system} or (throw "Unsupported system: ${stdenv.hostPlatform.system}")
    );

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
      categories = [
        "AudioVideo"
        "Audio"
        "AudioVideoEditing"
      ];
    })
    (makeDesktopItem {
      name = "stereotool-jack";
      desktopName = "Stereotool-Jack";
      exec = "stereo_tool_gui_jack";
      icon = "stereo-tool-icon";
      comment = "Broadcast Audio Processing";
      categories = [
        "AudioVideo"
        "Audio"
        "AudioVideoEditing"
      ];
    })
  ];

  buildInputs = [
    libx11
    alsa-lib
    bzip2
    zlib
    libxpm
    libgcc
  ];

  installPhase = ''
    runHook preInstall
    install -Dm755 alsa $out/bin/stereo_tool_gui
    wrapProgram $out/bin/stereo_tool_gui --prefix PATH : ${lib.makeBinPath [ kdePackages.kdialog ]}
    install -Dm755 jack $out/bin/stereo_tool_gui_jack
    wrapProgram $out/bin/stereo_tool_gui_jack --prefix PATH : ${lib.makeBinPath [ kdePackages.kdialog ]}
    install -Dm755 cmd $out/bin/stereo_tool_cmd
    mkdir -p $out/share/icons/hicolor/48x48/apps
    cp stereo-tool-icon.png $out/share/icons/hicolor/48x48/apps/stereo-tool-icon.png
    runHook postInstall
  '';

  meta = {
    homepage = "https://www.thimeo.com/stereo-tool/";
    description = "Stereo Tool is a software-based audio processor which offers outstanding audio quality and comes with many unique features";
    license = lib.licenses.unfree;
    mainProgram = "stereo_tool_gui";
    platforms = [
      "aarch64-linux"
      "aarch32-linux"
      "x86_64-linux"
      "i686-linux"
    ];
    maintainers = with lib.maintainers; [ RudiOnTheAir ];
  };

}
