{ lib
, stdenv
, flutter
, python3
, fetchFromGitHub
, fetchurl
, undmg
, pcre2
, libnotify
, libappindicator
, pkg-config
, gnome
, makeWrapper
, removeReferencesTo
}:

let
  pname = "yubioath-flutter";
  version = "6.4.0";

  baseMeta = with lib; {
    description = "Yubico Authenticator for Desktop";
    homepage = "https://github.com/Yubico/yubioath-flutter";
    license = licenses.asl20;
    maintainers = with maintainers; [ lukegb ];
  };

  linux = flutter.buildFlutterApplication rec {
    inherit pname version;

    src = fetchFromGitHub {
      owner = "Yubico";
      repo = "yubioath-flutter";
      rev = version;
      hash = "sha256-aXUnmKEUCi0rsVr3HVhEk6xa1z9HMsH+0AIY531hqiU=";
    };

    passthru.helper = python3.pkgs.callPackage ./helper.nix { inherit src version meta; };

    pubspecLock = lib.importJSON ./pubspec.lock.json;
    gitHashes = {
      window_manager = "sha256-mLX51nbWFccsAfcqLQIYDjYz69y9wAz4U1RZ8TIYSj0=";
    };

    postPatch = ''
      rm -f pubspec.lock

      substituteInPlace linux/CMakeLists.txt \
        --replace-fail "../build/linux/helper" "${passthru.helper}/libexec/helper"    '';

    preInstall = ''
      # Make sure we have permission to delete things CMake has copied in to our build directory from elsewhere.
      chmod -R +w build
    '';

    postInstall = ''
      # Swap the authenticator-helper symlink with the correct symlink.
      ln -fs "${passthru.helper}/bin/authenticator-helper" "$out/app/helper/authenticator-helper"

      # Move the icon.
      mkdir $out/share/icons
      mv $out/app/linux_support/com.yubico.yubioath.png $out/share/icons

      # Cleanup.
      rm -rf \
        "$out/app/README.adoc" \
        "$out/app/desktop_integration.sh" \
        "$out/app/linux_support" \
        $out/bin/* # We will repopulate this directory later.

      # Symlink binary.
      ln -sf "$out/app/authenticator" "$out/bin/yubioath-flutter"

      # Set the correct path to the binary in desktop file.
      substituteInPlace "$out/share/applications/com.yubico.authenticator.desktop" \
        --replace "@EXEC_PATH/authenticator" "$out/bin/yubioath-flutter" \
        --replace "@EXEC_PATH/linux_support/com.yubico.yubioath.png" "$out/share/icons/com.yubico.yubioath.png"
    '';

    # Needed for QR scanning to work
    extraWrapProgramArgs = ''
      --prefix PATH : ${lib.makeBinPath [ gnome.gnome-screenshot ]}
    '';

    nativeBuildInputs = [
      makeWrapper
      removeReferencesTo
      pkg-config
    ];

    buildInputs = [
      pcre2
      libnotify
      libappindicator
    ];

    meta = baseMeta // {
      sourceProvenance = with lib.sourceTypes; [ binaryNativeCode ];
      platforms = [ "x86_64-linux" "aarch64-linux" ];
    };
  };

  darwin = stdenv.mkDerivation {
    inherit pname version;

    src = fetchurl {
      url = "https://github.com/Yubico/yubioath-flutter/releases/download/${version}/yubico-authenticator-${version}-mac.dmg";
      hash = "sha256-vhk8F614RDZvzGdsxipt6MKi8fI+FPD1VkFp3DTusMg=";
    };

    nativeBuildInputs = [ undmg ];

    sourceRoot = ".";

    installPhase = ''
      mkdir -p $out/Applications
      cp -r *.app $out/Applications
    '';

    meta = baseMeta // {
      sourceProvenance = with lib.sourceTypes; [ binaryNativeCode ];
      platforms = [ "x86_64-darwin" "aarch64-darwin" ];
    };
  };
in
if stdenv.isDarwin
then darwin
else linux
