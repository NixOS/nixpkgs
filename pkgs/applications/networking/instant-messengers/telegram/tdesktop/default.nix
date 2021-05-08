{ mkDerivation, lib, fetchurl, fetchpatch, callPackage
, pkg-config, cmake, ninja, python3, wrapGAppsHook, wrapQtAppsHook, removeReferencesTo
, qtbase, qtimageformats, gtk3, libsForQt5, enchant2, lz4, xxHash
, dee, ffmpeg, openalSoft, minizip, libopus, alsaLib, libpulseaudio, range-v3
, tl-expected, hunspell, glibmm, webkitgtk
# Transitive dependencies:
, pcre, xorg, util-linux, libselinux, libsepol, epoxy
, at-spi2-core, libXtst, libthai, libdatrie
, xdg-utils
}:

with lib;

# Main reference:
# - This package was originally based on the Arch package but all patches are now upstreamed:
#   https://git.archlinux.org/svntogit/community.git/tree/trunk/PKGBUILD?h=packages/telegram-desktop
# Other references that could be useful:
# - https://git.alpinelinux.org/aports/tree/testing/telegram-desktop/APKBUILD
# - https://github.com/void-linux/void-packages/blob/master/srcpkgs/telegram-desktop/template

let
  tg_owt = callPackage ./tg_owt.nix {};
  webviewPatch = fetchpatch {
    url = "https://raw.githubusercontent.com/archlinux/svntogit-community/013eff77a13b6c2629a04e07a4d09dbe60c8ca48/trunk/fix-webview-includes.patch";
    sha256 = "0112zaysf3f02dd4bgqc5hwg66h1bfj8r4yjzb06sfi0pl9vl96l";
  };

in mkDerivation rec {
  pname = "telegram-desktop";
  version = "2.7.4";

  # Telegram-Desktop with submodules
  src = fetchurl {
    url = "https://github.com/telegramdesktop/tdesktop/releases/download/v${version}/tdesktop-${version}-full.tar.gz";
    sha256 = "1cigqvxa8lp79y7sp2w2izmmikxaxzrq9bh5ns3cy16z985nyllp";
  };

  postPatch = ''
    substituteInPlace Telegram/lib_spellcheck/spellcheck/platform/linux/linux_enchant.cpp \
      --replace '"libenchant-2.so.2"' '"${enchant2}/lib/libenchant-2.so.2"'
    substituteInPlace Telegram/CMakeLists.txt \
      --replace '"''${TDESKTOP_LAUNCHER_BASENAME}.appdata.xml"' '"''${TDESKTOP_LAUNCHER_BASENAME}.metainfo.xml"'
    patch -d Telegram/lib_webview -p1 < "${webviewPatch}"
  '';

  # We want to run wrapProgram manually (with additional parameters)
  dontWrapGApps = true;
  dontWrapQtApps = true;

  nativeBuildInputs = [ pkg-config cmake ninja python3 wrapGAppsHook wrapQtAppsHook removeReferencesTo ];

  buildInputs = [
    qtbase qtimageformats gtk3 libsForQt5.kwayland libsForQt5.libdbusmenu enchant2 lz4 xxHash
    dee ffmpeg openalSoft minizip libopus alsaLib libpulseaudio range-v3
    tl-expected hunspell glibmm webkitgtk
    tg_owt
    # Transitive dependencies:
    pcre xorg.libpthreadstubs xorg.libXdmcp util-linux libselinux libsepol epoxy
    at-spi2-core libXtst libthai libdatrie
  ];

  cmakeFlags = [
    "-Ddisable_autoupdate=ON"
    # We're allowed to used the API ID of the Snap package:
    "-DTDESKTOP_API_ID=611335"
    "-DTDESKTOP_API_HASH=d524b414d21f4d37f08684c1df41ac9c"
    #"-DDESKTOP_APP_SPECIAL_TARGET=\"\"" # TODO: Error when set to "": Bad special target '""'
    "-DTDESKTOP_LAUNCHER_BASENAME=telegramdesktop" # Note: This is the default
  ];

  # Note: The following packages could be packaged system-wide, but it's
  # probably best to use the bundled ones from tdesktop (Arch does this too):
  # rlottie:
  # - CMake flag: "-DTDESKTOP_USE_PACKAGED_TGVOIP=ON"
  # - Sources (problem: there are no stable releases!):
  #   - desktop-app (tdesktop): https://github.com/desktop-app/rlottie
  #   - upstream: https://github.com/Samsung/rlottie
  # libtgvoip:
  # - CMake flag: "-DDESKTOP_APP_USE_PACKAGED_RLOTTIE=ON"
  # - Sources  (problem: the stable releases might be too old!):
  #   - tdesktop: https://github.com/telegramdesktop/libtgvoip
  #   - upstream: https://github.com/grishka/libtgvoip
  # Both of these packages are included in this PR (kotatogram-desktop):
  # https://github.com/NixOS/nixpkgs/pull/75210
  # TODO: Package mapbox-variant

  postFixup = ''
    # This is necessary to run Telegram in a pure environment.
    # We also use gappsWrapperArgs from wrapGAppsHook.
    wrapProgram $out/bin/telegram-desktop \
      "''${gappsWrapperArgs[@]}" \
      "''${qtWrapperArgs[@]}" \
      --prefix PATH : ${xdg-utils}/bin \
      --set XDG_RUNTIME_DIR "XDG-RUNTIME-DIR"
    sed -i $out/bin/telegram-desktop \
      -e "s,'XDG-RUNTIME-DIR',\"\''${XDG_RUNTIME_DIR:-/run/user/\$(id --user)}\","
  '';

  passthru = {
    inherit tg_owt;
  };

  meta = {
    description = "Telegram Desktop messaging app";
    longDescription = ''
      Desktop client for the Telegram messenger, based on the Telegram API and
      the MTProto secure protocol.
    '';
    license = licenses.gpl3;
    platforms = platforms.linux;
    homepage = "https://desktop.telegram.org/";
    changelog = "https://github.com/telegramdesktop/tdesktop/releases/tag/v{version}";
    maintainers = with maintainers; [ primeos abbradar ];
  };
}
