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
  version = "0.5.1";

  src = fetchFromGitHub {
    owner = "saivert";
    repo = "pwvucontrol";
    tag = finalAttrs.version;
    hash = "sha256-21TBVDzjrBzNIPkAURGs2ngI8Vj6o/RL3Ael4wwE2Lk=";
  };

  cargoDeps = rustPlatform.fetchCargoVendor {
    inherit (finalAttrs) pname version src;
    hash = "sha256-FrPpLbfqM/DtjYu20pwr1AMUHaAuTEt60I3JlFZO4RI=";
  };

  postPatch = ''
    substituteInPlace src/meson.build --replace-fail \
      "'src' / rust_target / meson.project_name()," \
      "'src' / '${stdenv.hostPlatform.rust.cargoShortTarget}' / rust_target / meson.project_name(),"
  '';

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

  # For https://github.com/saivert/pwvucontrol/blob/7bf43c746cd49fffbfb244ac4474742c6b3737a9/src/meson.build#L45-L46
  env.CARGO_BUILD_TARGET = stdenv.hostPlatform.rust.rustcTargetSpec;

  meta = {
    description = "Pipewire Volume Control";
    homepage = "https://github.com/saivert/pwvucontrol";
    license = lib.licenses.gpl3Plus;
    maintainers = with lib.maintainers; [
      Guanran928
      johnrtitor
    ];
    mainProgram = "pwvucontrol";
    platforms = lib.platforms.linux;
  };
})
