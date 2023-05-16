{ lib
<<<<<<< HEAD
, writeText
, flutter
, python3
, fetchFromGitHub
, pcre2
, libnotify
, libappindicator
, pkg-config
=======
, flutter37
, python3
, fetchFromGitHub
, pcre2
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
, gnome
, makeWrapper
, removeReferencesTo
}:

<<<<<<< HEAD
flutter.buildFlutterApplication rec {
  pname = "yubioath-flutter";
  version = "6.2.0";
=======
flutter37.buildFlutterApplication rec {
  pname = "yubioath-flutter";
  version = "6.1.0";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)

  src = fetchFromGitHub {
    owner = "Yubico";
    repo = "yubioath-flutter";
    rev = version;
<<<<<<< HEAD
    hash = "sha256-NgzijuvyWNl9sFQzq1Jzk1povF8c/rKuVyVKeve+Vic=";
=======
    sha256 = "sha256-N9/qwC79mG9r+zMPLHSPjNSQ+srGtnXuKsf0ijtH7CI=";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
  };

  passthru.helper = python3.pkgs.callPackage ./helper.nix { inherit src version meta; };

<<<<<<< HEAD
  pubspecLockFile = ./pubspec.lock;
  depsListFile = ./deps.json;
  vendorHash = "sha256-RV7NoXJnd1jYGcU5YE0VV7VlMM7bz2JTMJTImOY3m38=";

  postPatch = ''
    rm -f pubspec.lock
    ln -s "${writeText "${pname}-overrides.yaml" (builtins.toJSON {
      dependency_overrides.intl = "^0.18.1";
    })}" pubspec_overrides.yaml

=======
  depsListFile = ./deps.json;
  vendorHash = "sha256-WfZiB7MO4wHUg81xm67BMu4zQdC9CfhN5BQol+AI2S8=";

  postPatch = ''
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
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

    # Needed for QR scanning to work.
    wrapProgram "$out/bin/yubioath-flutter" \
      --prefix PATH : ${lib.makeBinPath [ gnome.gnome-screenshot ]}

    # Set the correct path to the binary in desktop file.
    substituteInPlace "$out/share/applications/com.yubico.authenticator.desktop" \
      --replace "@EXEC_PATH/authenticator" "$out/bin/yubioath-flutter" \
      --replace "@EXEC_PATH/linux_support/com.yubico.yubioath.png" "$out/share/icons/com.yubico.yubioath.png"
<<<<<<< HEAD
=======

    # Remove unnecessary references to Flutter.
    remove-references-to -t ${flutter37.unwrapped} $out/app/data/flutter_assets/shaders/ink_sparkle.frag
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
  '';

  nativeBuildInputs = [
    makeWrapper
    removeReferencesTo
<<<<<<< HEAD
    pkg-config
=======
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
  ];

  buildInputs = [
    pcre2
<<<<<<< HEAD
    libnotify
    libappindicator
=======
  ];

  disallowedReferences = [
    flutter37
    flutter37.unwrapped
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
  ];

  meta = with lib; {
    description = "Yubico Authenticator for Desktop";
    homepage = "https://github.com/Yubico/yubioath-flutter";
    license = licenses.asl20;
    maintainers = with maintainers; [ lukegb ];
    platforms = [ "x86_64-linux" "aarch64-linux" ];
  };
}
