{ lib
, stdenv
, fetchFromGitLab
, meson
, ninja
, pkg-config
, gnome
, gnome-desktop
, glib
, gtk3
, wayland
, wayland-protocols
, libxml2
, libxkbcommon
, rustPlatform
, feedbackd
, wrapGAppsHook
, fetchpatch
}:

stdenv.mkDerivation rec {
  pname = "squeekboard";
  version = "1.17.0";

  src = fetchFromGitLab {
    domain = "gitlab.gnome.org";
    group = "World";
    owner = "Phosh";
    repo = pname;
    rev = "v${version}";
    sha256 = "sha256-U46OQ0bXkXv6za8vUZxtbxJKqiF/X/xxJsqQGpnRIpg=";
  };

  cargoDeps = rustPlatform.fetchCargoTarball {
    inherit src;
    cargoUpdateHook = ''
      cat Cargo.toml.in Cargo.deps > Cargo.toml
    '';
    name = "${pname}-${version}";
    sha256 = "sha256-4q8MW1n/xu538+R5ZlA+p/hd6pOQPKj7jOFwnuMc7sk=";
  };

  nativeBuildInputs = [
    meson
    ninja
    pkg-config
    glib
    wayland
    wrapGAppsHook
  ] ++ (with rustPlatform; [
    cargoSetupHook
    rust.cargo
    rust.rustc
  ]);

  buildInputs = [
    gtk3
    gnome-desktop
    wayland
    wayland-protocols
    libxml2
    libxkbcommon
    feedbackd
  ];

  meta = with lib; {
    description = "A virtual keyboard supporting Wayland";
    homepage = "https://source.puri.sm/Librem5/squeekboard";
    license = licenses.gpl3Plus;
    maintainers = with maintainers; [ artturin ];
    platforms = platforms.linux;
  };
}
