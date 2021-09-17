{ mkDerivation, lib, fetchFromGitHub, callPackage
, pkg-config, cmake, ninja, python3, wrapGAppsHook, wrapQtAppsHook
, qtbase, qtimageformats, gtk3, libsForQt5, lz4, xxHash
, ffmpeg, openalSoft, minizip, libopus, alsa-lib, libpulseaudio, range-v3
, tl-expected, hunspell, glibmm, webkitgtk
# Transitive dependencies:
, pcre, xorg, util-linux, libselinux, libsepol, epoxy
, at-spi2-core, libXtst, libthai, libdatrie
}:

with lib;

let
  tg_owt = callPackage ./tg_owt.nix {};
in mkDerivation rec {
  pname = "kotatogram-desktop";
  version = "1.4.1";

  src = fetchFromGitHub {
    owner = "kotatogram";
    repo = "kotatogram-desktop";
    rev = "k${version}";
    sha256 = "07z56gz3sk45n5j0gw9p9mxrbwixxsmp7lvqc6lqnxmglz6knc1d";
    fetchSubmodules = true;
  };

  postPatch = ''
    substituteInPlace Telegram/CMakeLists.txt \
      --replace '"''${TDESKTOP_LAUNCHER_BASENAME}.appdata.xml"' '"''${TDESKTOP_LAUNCHER_BASENAME}.metainfo.xml"'
  '';

  # We want to run wrapProgram manually (with additional parameters)
  dontWrapGApps = true;
  dontWrapQtApps = true;

  nativeBuildInputs = [ pkg-config cmake ninja python3 wrapGAppsHook wrapQtAppsHook ];

  buildInputs = [
    qtbase qtimageformats gtk3 libsForQt5.kwayland libsForQt5.libdbusmenu lz4 xxHash
    ffmpeg openalSoft minizip libopus alsa-lib libpulseaudio range-v3
    tl-expected hunspell glibmm webkitgtk
    tg_owt
    # Transitive dependencies:
    pcre xorg.libXdmcp util-linux libselinux libsepol epoxy
    at-spi2-core libXtst libthai libdatrie
  ];

  cmakeFlags = [ "-DTDESKTOP_API_TEST=ON" ];

  postFixup = ''
    # We also use gappsWrapperArgs from wrapGAppsHook.
    wrapProgram $out/bin/kotatogram-desktop \
      "''${gappsWrapperArgs[@]}" \
      "''${qtWrapperArgs[@]}"
  '';

  passthru = {
    inherit tg_owt;
  };

  meta = {
    description = "Kotatogram – experimental Telegram Desktop fork";
    longDescription = ''
      Unofficial desktop client for the Telegram messenger, based on Telegram Desktop.

      It contains some useful (or purely cosmetic) features, but they could be unstable. A detailed list is available here: https://kotatogram.github.io/changes
    '';
    license = licenses.gpl3;
    platforms = platforms.linux;
    homepage = "https://kotatogram.github.io";
    changelog = "https://github.com/kotatogram/kotatogram-desktop/releases/tag/k{ver}";
    maintainers = with maintainers; [ ilya-fedin ];
  };
}
