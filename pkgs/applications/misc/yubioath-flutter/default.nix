{ lib
, flutter
, python3
, fetchFromGitHub
, stdenv
, pcre2
, gnome
, makeWrapper
}:
let
  vendorHashes = {
    x86_64-linux = "sha256-BwhWA8N0S55XkljDKPNkDhsj0QSpmJJ5MwEnrPjymS8=";
    aarch64-linux = "sha256-T1aGz3+2Sls+rkUVDUo39Ky2igg+dxGSUaf3qpV7ovQ=";
  };
in
flutter.mkFlutterApp rec {
  pname = "yubioath-flutter";
  version = "6.0.2";

  src = fetchFromGitHub {
    owner = "Yubico";
    repo = "yubioath-flutter";
    rev = version;
    sha256 = "13nh5qpq02c6azfdh4cbzhlrq0hs9is45q5z5cnxg84hrx26hd4k";
  };

  passthru.helper = python3.pkgs.callPackage ./helper.nix { inherit src version meta; };

  vendorHash = vendorHashes.${stdenv.system};

  postPatch = ''
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
  ];

  buildInputs = [
    pcre2
  ];

  meta = with lib; {
    description = "Yubico Authenticator for Desktop";
    homepage = "https://github.com/Yubico/yubioath-flutter";
    license = licenses.asl20;
    maintainers = with maintainers; [ lukegb ];
    platforms = builtins.attrNames vendorHashes;
  };
}
