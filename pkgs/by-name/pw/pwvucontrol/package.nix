{
  lib,
  stdenv,
  fetchFromGitHub,
  fetchFromGitLab,
  fetchpatch,
  cargo,
  desktop-file-utils,
  meson,
  ninja,
  pkg-config,
  rustPlatform,
  rustc,
  wrapGAppsHook4,
  cairo,
  gdk-pixbuf,
  glib,
  gtk4,
  libadwaita,
  pango,
  pipewire,
  wireplumber,
}:

let
  wireplumber_0_4 = wireplumber.overrideAttrs (attrs: rec {
    version = "0.4.17";
    src = fetchFromGitLab {
      domain = "gitlab.freedesktop.org";
      owner = "pipewire";
      repo = "wireplumber";
      tag = version;
      hash = "sha256-vhpQT67+849WV1SFthQdUeFnYe/okudTQJoL3y+wXwI=";
    };

    patches = [
      (fetchpatch {
        url = "https://gitlab.freedesktop.org/pipewire/wireplumber/-/commit/f4f495ee212c46611303dec9cd18996830d7f721.patch";
        hash = "sha256-dxVlXFGyNvWKZBrZniFatPPnK+38pFGig7LGAsc6Ydc=";
      })
    ];
  });
in
stdenv.mkDerivation (finalAttrs: {
  pname = "pwvucontrol";
  version = "0.4.9";

  src = fetchFromGitHub {
    owner = "saivert";
    repo = "pwvucontrol";
    tag = finalAttrs.version;
    hash = "sha256-fmEXVUz3SerVgWijT/CAoelSUzq861AkBVjP5qwS0ao=";
  };

  cargoDeps = rustPlatform.fetchCargoVendor {
    inherit (finalAttrs) pname version src;
    hash = "sha256-oQSH4P9WxvkXZ53KM5ZoRAZyQFt60Zz7guBbgT1iiBk=";
  };

  nativeBuildInputs = [
    cargo
    desktop-file-utils
    meson
    ninja
    pkg-config
    rustPlatform.bindgenHook
    rustPlatform.cargoSetupHook
    rustc
    wrapGAppsHook4
  ];

  buildInputs = [
    cairo
    gdk-pixbuf
    glib
    gtk4
    libadwaita
    pango
    pipewire
    wireplumber_0_4
  ];

  meta = {
    description = "Pipewire Volume Control";
    homepage = "https://github.com/saivert/pwvucontrol";
    license = lib.licenses.gpl3Plus;
    maintainers = with lib.maintainers; [
      figsoda
      Guanran928
      johnrtitor
    ];
    mainProgram = "pwvucontrol";
    platforms = lib.platforms.linux;
  };
})
