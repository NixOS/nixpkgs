{ lib
, stdenv
, fetchFromGitLab
, pkg-config
, meson
, ninja
, zbar
, pipewire
, clang
, libclang
, python37
, desktop-file-utils
, rustPlatform
, glib
, gtk4
, gst_all_1
, libadwaita
, sqlite
, wrapGAppsHook
}:

stdenv.mkDerivation rec {
  pname = "decoder";
  version = "0.2.2";

  src = fetchFromGitLab {
    domain = "gitlab.gnome.org";
    owner = "World";
    repo = "decoder";
    rev = "${version}";
    sha256 = "1d7ljyfxl5zkmcmp6rw42dsy2h07332gna7vs2px9fkwrgbzd843";
  };

  cargoDeps = rustPlatform.fetchCargoTarball {
    inherit src;
    sha256 = "0qqp30s81jv3l479m3gsnb35200521pbah7mx1y6vzr9s8qdzcld";
  };

  nativeBuildInputs = [
    pkg-config
    meson
    ninja
    glib
    zbar
    pipewire
    clang
    libclang
    python37
    desktop-file-utils
    wrapGAppsHook
  ] ++ (with rustPlatform; [
    cargoSetupHook
    rust.cargo
    rust.rustc
  ]);

  buildInputs = [
    glib
    gtk4
    libadwaita
    sqlite
  ] ++ (with gst_all_1; [
    gstreamer
    gstreamermm
    gst-plugins-bad
  ]);

  LIBCLANG_PATH = "${libclang.lib}/lib";

  postPatch = ''
    chmod +x build-aux/meson/postinstall.py # patchShebangs requires executable file
    patchShebangs build-aux/meson/postinstall.py
  '';

  meta = with lib; {
    description = "Scan and Generate QR Codes";
    homepage = "https://apps.gnome.org/en/app/com.belmoussaoui.Decoder/";
    license = licenses.gpl3Plus;
    maintainers = with maintainers; [ mihnea-s ];
    platforms = [ "x86_64-linux" ];
  };
}
