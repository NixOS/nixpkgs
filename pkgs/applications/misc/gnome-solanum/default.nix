{ lib
, stdenv
, fetchFromGitLab
, rustPlatform
, desktop-file-utils
, meson
, ninja
, pkg-config
, wrapGAppsHook
, python3
, git
, glib
, gtk4
, gst_all_1
, libadwaita
}:

stdenv.mkDerivation rec {
  pname = "solanum";
  version = "3.0.1";

  src = fetchFromGitLab {
    domain = "gitlab.gnome.org";
    owner = "World";
    repo = "Solanum";
    rev = "v${version}";
    sha256 = "0cga6cz6jfbipzp008rjznkz7844licdc34lk133fcyqil0cg0ap";
  };

  cargoDeps = rustPlatform.fetchCargoTarball {
    inherit src;
    name = "${pname}-${version}";
    sha256 = "10kzv98b2fiql9f6n2fv6lrgq4fdzxq0h4nzcq9jrw3fsggzl0wb";
  };

  postPatch = ''
    patchShebangs build-aux
  '';

  nativeBuildInputs = [
    meson
    ninja
    pkg-config
    wrapGAppsHook
    python3
    git
    desktop-file-utils
  ] ++ (with rustPlatform; [
    cargoSetupHook
    rust.cargo
    rust.rustc
  ]);

  buildInputs = [
    glib
    gtk4
    libadwaita
    gst_all_1.gstreamer
    gst_all_1.gst-plugins-base
    gst_all_1.gst-plugins-bad
  ];

  meta = with lib; {
    homepage = "https://gitlab.gnome.org/World/Solanum";
    description = "A pomodoro timer for the GNOME desktop";
    maintainers = with maintainers; [ linsui ];
    license = licenses.gpl3Plus;
    platforms = platforms.linux;
  };
}
