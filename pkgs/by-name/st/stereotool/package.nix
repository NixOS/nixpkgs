{
  lib,
  stdenv,
  fetchurl,
  autoPatchelfHook,
  libX11,
  libXpm,
  libXfixes,
  jack2,
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
  version = "10.72";

  srcs =
    let
      versionNoPoint = lib.replaceStrings [ "." ] [ "" ] version;
    in
    [
      (fetchurl {
        name = "stereo-tool-icon.png";
        url = "https://download.thimeo.com/stereo_tool_icon_${versionNoPoint}.png";
        hash = "sha256:0qr01d0gpp21sip56kpd47ysk68kp3sd5g6ryx89gvlwl0gszj3m";
      })
    ]
    ++ (
      {
        # Alsa version for 64bits.
        x86_64-linux = [
          (fetchurl {
            name = "alsa";
            url = "https://download.thimeo.com/stereo_tool_gui_64_${versionNoPoint}";
            hash = "sha256:07rk25wbkjmc817plcjb0j32hmjnga4f4vqlqbdzfxkj4gd1ivpz";
          })
          # Jack version for 64bits.
          (fetchurl {
            name = "jack";
            url = "https://download.thimeo.com/stereo_tool_gui_jack_64_${versionNoPoint}";
            hash = "sha256:07rk25wbkjmc817plcjb0j32hmjnga4f4vqlqbdzfxkj4gd1ivpz";
          })
          # Cmd version for 64bits
          (fetchurl {
            name = "cmd";
            url = "https://download.thimeo.com/stereo_tool_cmd_64_${versionNoPoint}";
            hash = "sha256:0jbd5fapcdni4c5x8r4n06yxphrs8lxpswmv998wkqxfscb06n7z";
          })
        ];
        # Sources if the system is aarch64-linux
        aarch64-linux = [
          (fetchurl {
            name = "alsa";
            url = "https://download.thimeo.com/stereo_tool_gui_pi2_64_${versionNoPoint}";
            hash = "sha256:05kjghnwzmahb9ib52ksynrkp8vpbmsigvhfjmbffksjmics8714";
          })
          (fetchurl {
            name = "jack";
            url = "https://download.thimeo.com/stereo_tool_gui_jack_pi2_64_${versionNoPoint}";
            hash = "sha256:05kjghnwzmahb9ib52ksynrkp8vpbmsigvhfjmbffksjmics8714";
          })
          (fetchurl {
            name = "cmd";
            url = "https://download.thimeo.com/stereo_tool_pi2_64_${versionNoPoint}";
            hash = "sha256:0m8l4g3hifamg3pcp9wqv0y59x0sazzw5l907crbh75c7rrz14zq";
          })
        ];
        # Sources if the system is aarch32-linux
        aarch32-linux = [
          (fetchurl {
            name = "alsa";
            url = "https://download.thimeo.com/stereo_tool_gui_pi2_${versionNoPoint}";
            hash = "sha256:08169sjawi08fyc2anfbghg7bcpsgcg2y19a0vplzs8zbapn7adf";
          })
          (fetchurl {
            name = "jack";
            url = "https://download.thimeo.com/stereo_tool_gui_jack_pi2_${versionNoPoint}";
            hash = "sha256:08169sjawi08fyc2anfbghg7bcpsgcg2y19a0vplzs8zbapn7adf";
          })
          (fetchurl {
            name = "cmd";
            url = "https://download.thimeo.com/stereo_tool_pi2_${versionNoPoint}";
            hash = "sha256:0bmdg4k1rr9avvmzmqsax9lsv8gmz28whvwr81q8kl0yygvaqanf";
          })
        ];
        # Sources if the system is 32bits i686
        i686-linux = [
          (fetchurl {
            # The name is the name of this source in the build directory
            name = "alsa";
            url = "https://download.thimeo.com/stereo_tool_gui_${versionNoPoint}";
            hash = "sha256:188wj32am1g91h24wz0pdw9bdac9ymbpfnq6bnl49p4qw48a44j3";
          })
          (fetchurl {
            name = "jack";
            url = "https://download.thimeo.com/stereo_tool_gui_jack_${versionNoPoint}";
            hash = "sha256:188wj32am1g91h24wz0pdw9bdac9ymbpfnq6bnl49p4qw48a44j3";
          })
          (fetchurl {
            name = "cmd";
            url = "https://download.thimeo.com/stereo_tool_cmd_${versionNoPoint}";
            hash = "sha256:0qq6b6dnylm1anslfwqs6z096gnkfl9bkixmly9a8gbgzx6k8hvn";
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
    libXfixes
    jack2
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
