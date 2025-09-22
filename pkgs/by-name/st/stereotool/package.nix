{
  lib,
  stdenv,
  fetchurl,
  autoPatchelfHook,
  libX11,
  libXpm,
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
  version = "10.51";

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
            hash = "sha256-sMgqbfJhIBuYf6nvxs4R/XmiOBHnVOp2ORcU5+CNtLM=";
          })
          # Jack version for 64bits.
          (fetchurl {
            name = "jack";
            url = "https://download.thimeo.com/stereo_tool_gui_jack_64_${versionNoPoint}";
            hash = "sha256-sMgqbfJhIBuYf6nvxs4R/XmiOBHnVOp2ORcU5+CNtLM=";
          })
          # Cmd version for 64bits
          (fetchurl {
            name = "cmd";
            url = "https://download.thimeo.com/stereo_tool_cmd_64_${versionNoPoint}";
            hash = "sha256-x+2JwIy2uLx+QfjayOhY+MYYEQYvAt5O7y+KWn3jcVU=";
          })
        ];
        # Sources if the system is aarch64-linux
        aarch64-linux = [
          (fetchurl {
            name = "alsa";
            url = "https://download.thimeo.com/stereo_tool_gui_pi2_64_${versionNoPoint}";
            hash = "sha256-Gb0YPgEsd7xvvcCL+MC9ZFAsh0ciJOsmJn1ZIdkZw7Q=";
          })
          (fetchurl {
            name = "jack";
            url = "https://download.thimeo.com/stereo_tool_gui_jack_pi2_64_${versionNoPoint}";
            hash = "sha256-Gb0YPgEsd7xvvcCL+MC9ZFAsh0ciJOsmJn1ZIdkZw7Q=";
          })
          (fetchurl {
            name = "cmd";
            url = "https://download.thimeo.com/stereo_tool_pi2_64_${versionNoPoint}";
            hash = "sha256-KA69G6Vknx8Sle8f2O+OjO88ZYGSv4khYrWIsoHVAoc=";
          })
        ];
        # Sources if the system is aarch32-linux
        aarch32-linux = [
          (fetchurl {
            name = "alsa";
            url = "https://download.thimeo.com/stereo_tool_gui_pi2_${versionNoPoint}";
            hash = "sha256-vjZ/nB4tZ7YVYmclX0Uukgx/JwTv6jjdAfYjloo7a8E=";
          })
          (fetchurl {
            name = "jack";
            url = "https://download.thimeo.com/stereo_tool_gui_jack_pi2_${versionNoPoint}";
            hash = "sha256-vjZ/nB4tZ7YVYmclX0Uukgx/JwTv6jjdAfYjloo7a8E=";
          })
          (fetchurl {
            name = "cmd";
            url = "https://download.thimeo.com/stereo_tool_pi2_${versionNoPoint}";
            hash = "sha256-YUCpCzv3GrQEoeyZFwOTcoHu9msciqmViboVu1LBG3g=";
          })
        ];
        # Sources if the system is 32bits i686
        i686-linux = [
          (fetchurl {
            # The name is the name of this source in the build directory
            name = "alsa";
            url = "https://download.thimeo.com/stereo_tool_gui_${versionNoPoint}";
            hash = "sha256-/l/2sx3v14R83Vqvmc5AqMQzmovww7hk4kTqN2U2Mqs=";
          })
          (fetchurl {
            name = "jack";
            url = "https://download.thimeo.com/stereo_tool_gui_jack_${versionNoPoint}";
            hash = "sha256-/l/2sx3v14R83Vqvmc5AqMQzmovww7hk4kTqN2U2Mqs=";
          })
          (fetchurl {
            name = "cmd";
            url = "https://download.thimeo.com/stereo_tool_cmd_${versionNoPoint}";
            hash = "sha256-lPNg58u163DcWk11jbg8l77OdqX+6rVQalGmEXD674s=";
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
    wrapProgram $out/bin/stereo_tool_gui --prefix PATH : ${lib.makeBinPath [ kdePackages.kdialog ]}
    install -Dm755 jack $out/bin/stereo_tool_gui_jack
    wrapProgram $out/bin/stereo_tool_gui_jack --prefix PATH : ${lib.makeBinPath [ kdePackages.kdialog ]}
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
    platforms = [
      "aarch64-linux"
      "aarch32-linux"
      "x86_64-linux"
      "i686-linux"
    ];
    maintainers = with maintainers; [ RudiOnTheAir ];
  };

}
