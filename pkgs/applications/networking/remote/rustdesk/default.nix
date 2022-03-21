{ lib
, stdenv
, fetchFromGitHub
, makeDesktopItem
, copyDesktopItems
, makeWrapper
, rustPlatform
, cmake
, yasm
, nasm
, zip
, pkg-config
, clang
, gtk3
, xdotool
, libxcb
, libXfixes
, alsa-lib
, pulseaudio
, libXtst
, libvpx
, libyuv
, libopus
, libsciter
, llvmPackages
, wrapGAppsHook
}:

rustPlatform.buildRustPackage rec {
  pname = "rustdesk";
  version = "1.1.8";

  src = fetchFromGitHub {
    owner = "rustdesk";
    repo = "rustdesk";
    rev = "0325500ebf331b66220cec6e9078afb83b0e98a7";
    sha256 = "sha256-xglyyoiAjJx3y8+A2OYHZffjqjDkcTjIluPA/J42VVg=";
  };

  cargoSha256 = "sha256-4MQKa54f3X7IHGd29H6RY7v2toeHvTHInIpgXjdotjw=";

  LIBCLANG_PATH="${llvmPackages.libclang.lib}/lib";

  # Change magnus-opus version to upstream so that it does not use
  # vcpkg for libopus since it does not work.
  cargoPatches = [
    ./cargo.patch
  ];

  # Manually simulate a vcpkg installation so that it can link the libaries
  # properly.
  postUnpack = let
    vcpkg_target = "x64-linux";
  in ''
    export VCPKG_ROOT="$TMP/vcpkg";

    mkdir -p $VCPKG_ROOT/installed/${vcpkg_target}/lib

    ln -s ${libvpx.out}/lib/* $VCPKG_ROOT/installed/${vcpkg_target}/lib/
    ln -s ${libyuv.out}/lib/* $VCPKG_ROOT/installed/${vcpkg_target}/lib/
  '';

  nativeBuildInputs = [ pkg-config cmake makeWrapper copyDesktopItems yasm nasm clang wrapGAppsHook ];
  buildInputs = [ alsa-lib pulseaudio libXfixes libxcb xdotool gtk3 libvpx libopus libXtst libyuv ];

  # Checks require an active X display.
  doCheck = false;

  desktopItems = [ (makeDesktopItem {
    name = "rustdesk";
    exec = meta.mainProgram;
    icon = "rustdesk";
    desktopName = "RustDesk";
    comment = meta.description;
    genericName = "Remote Desktop";
    categories = ["Network"];
  }) ];

  # Add static ui resources and libsciter to same folder as binary so that it
  # can find them.
  postInstall = ''
    mkdir -p $out/{share/src,lib/rustdesk}

    # so needs to be next to the executable
    mv $out/bin/rustdesk $out/lib/rustdesk
    ln -s ${libsciter}/lib/libsciter-gtk.so $out/lib/rustdesk

    makeWrapper $out/lib/rustdesk/rustdesk $out/bin/rustdesk \
      --run "cd $out/share"

    cp -a $src/src/ui $out/share/src

    install -Dm0644 $src/logo.svg $out/share/icons/hicolor/scalable/apps/rustdesk.svg
  '';

  meta = with lib; {
    description = "Yet another remote desktop software";
    homepage = "https://rustdesk.com";
    license = licenses.gpl3Only;
    maintainers = with maintainers; [ leixb ];
    platforms = [ "x86_64-linux" ];
    mainProgram = "rustdesk";
  };
}
