{ lib
, flutter
, python3
, fetchFromGitHub
, pcre2
, libnotify
, libappindicator
, pkg-config
, gnome
, makeWrapper
, removeReferencesTo
}:

flutter.buildFlutterApplication rec {
  pname = "yubioath-flutter";
  version = "6.3.1";

  src = fetchFromGitHub {
    owner = "Yubico";
    repo = "yubioath-flutter";
    rev = version;
    hash = "sha256-XgRIX2Iv5niJw2NSBPwM0K4uF5sPj9c+Xj4oHtAQSbU=";
  };

  passthru.helper = python3.pkgs.callPackage ./helper.nix { inherit src version meta; };

  pubspecLock = lib.importJSON ./pubspec.lock.json;

  postPatch = ''
    rm -f pubspec.lock

    substituteInPlace linux/CMakeLists.txt \
      --replace "../build/linux/helper" "${passthru.helper}/libexec/helper"
  '';

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

  meta = with lib; {
    description = "Yubico Authenticator for Desktop";
    homepage = "https://github.com/Yubico/yubioath-flutter";
    license = licenses.asl20;
    maintainers = with maintainers; [ lukegb ];
    platforms = [ "x86_64-linux" "aarch64-linux" ];
  };
}
