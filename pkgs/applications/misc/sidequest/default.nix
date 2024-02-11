{ stdenv
, lib
, fetchurl
, buildFHSEnv
, makeDesktopItem
, makeWrapper
, alsa-lib
, at-spi2-atk
, cairo
, cups
, dbus
, expat
, gdk-pixbuf
, glib
, gtk3
, mesa
, nss
, nspr
, libdrm
, xorg
, libxkbcommon
, libxshmfence
, pango
, systemd
, icu
, openssl
, zlib
}:
  let
    pname = "sidequest";
    version = "0.10.33";

    desktopItem = makeDesktopItem rec {
      name = "SideQuest";
      exec = "SideQuest";
      desktopName = name;
      genericName = "VR App Store";
      categories = [ "Settings" "PackageManager" ];
    };

    sidequest = stdenv.mkDerivation {
      inherit pname version;

      src = fetchurl {
        url = "https://github.com/SideQuestVR/SideQuest/releases/download/v${version}/SideQuest-${version}.tar.xz";
        sha256 = "8ac3d97400a8e3ce86902b5bea7b8d042a092acd888d20e5139490a38507f995";
      };
      dontUnpack = true;

      nativeBuildInputs = [ makeWrapper ];

      installPhase = ''
        mkdir -p "$out/lib/SideQuest" "$out/bin"
        tar -xJf "$src" -C "$out/lib/SideQuest" --strip-components 1

        ln -s "$out/lib/SideQuest/sidequest" "$out/bin"
      '';

      postFixup = let
        libPath = lib.makeLibraryPath [
          alsa-lib
          at-spi2-atk
          cairo
          cups
          dbus
          expat
          gdk-pixbuf
          glib
          gtk3
          mesa
          nss
          nspr
          libdrm
          xorg.libX11
          xorg.libxcb
          xorg.libXcomposite
          xorg.libXdamage
          xorg.libXext
          xorg.libXfixes
          xorg.libXrandr
          xorg.libxshmfence
          libxkbcommon
          xorg.libxkbfile
          pango
          stdenv.cc.cc.lib
          systemd
        ];
      in ''
        patchelf \
          --set-interpreter "$(cat $NIX_CC/nix-support/dynamic-linker)" \
          --set-rpath "${libPath}:$out/lib/SideQuest" \
          "$out/lib/SideQuest/sidequest"
      '';
    };
  in buildFHSEnv {
    name = "SideQuest";

    passthru = {
      inherit pname version;

      meta = with lib; {
        description = "An open app store and side-loading tool for Android-based VR devices such as the Oculus Go, Oculus Quest or Moverio BT 300";
        homepage = "https://github.com/SideQuestVR/SideQuest";
        downloadPage = "https://github.com/SideQuestVR/SideQuest/releases";
        sourceProvenance = with sourceTypes; [ binaryNativeCode ];
        license = licenses.mit;
        maintainers = with maintainers; [ joepie91 rvolosatovs ];
        platforms = [ "x86_64-linux" ];
      };
    };

    targetPkgs = pkgs: [
      sidequest
      # Needed in the environment on runtime, to make QuestSaberPatch work
      icu openssl zlib
      libxkbcommon libxshmfence
    ];

    extraInstallCommands = ''
      mkdir -p "$out/share/applications"
      ln -s ${desktopItem}/share/applications/* "$out/share/applications"
    '';

    runScript = "sidequest";
  }
