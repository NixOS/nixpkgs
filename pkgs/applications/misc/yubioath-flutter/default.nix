{ lib
, writeText
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
  version = "6.2.0";

  src = fetchFromGitHub {
    owner = "Yubico";
    repo = "yubioath-flutter";
    rev = version;
    hash = "sha256-NgzijuvyWNl9sFQzq1Jzk1povF8c/rKuVyVKeve+Vic=";
  };

  passthru.helper = python3.pkgs.callPackage ./helper.nix { inherit src version meta; };

  pubspecLockFile = ./pubspec.lock;
  depsListFile = ./deps.json;
  vendorHash = "sha256-RV7NoXJnd1jYGcU5YE0VV7VlMM7bz2JTMJTImOY3m38=";

  postPatch = ''
    rm -f pubspec.lock
    ln -s "${writeText "${pname}-overrides.yaml" (builtins.toJSON {
      dependency_overrides.intl = "^0.18.1";
    })}" pubspec_overrides.yaml

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
