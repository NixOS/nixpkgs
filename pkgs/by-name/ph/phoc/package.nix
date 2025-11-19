{
  lib,
  stdenv,
  stdenvNoCC,
  fetchFromGitLab,
  meson,
  ninja,
  pkg-config,
  python3,
  wayland-scanner,
  wrapGAppsHook3,
  libinput,
  gobject-introspection,
  mutter,
  gnome-desktop,
  glib,
  gtk3,
  json-glib,
  wayland,
  libdrm,
  libxkbcommon,
  wlroots_0_19,
  xorg,
  nix-update-script,
  nixosTests,
  testers,
  gmobile,
}:

let
  # Derived from subprojects/gvdb.wrap
  gvdb = fetchFromGitLab {
    domain = "gitlab.gnome.org";
    owner = "GNOME";
    repo = "gvdb";
    rev = "4758f6fb7f889e074e13df3f914328f3eecb1fd3";
    hash = "sha256-4mqoHPlrMPenoGPwDqbtv4/rJ/uq9Skcm82pRvOxNIk=";
  };
in
stdenv.mkDerivation (finalAttrs: {
  pname = "phoc";
  version = "0.50.0";

  src = fetchFromGitLab {
    domain = "gitlab.gnome.org";
    group = "World";
    owner = "Phosh";
    repo = "phoc";
    rev = "v${finalAttrs.version}";
    hash = "sha256-Fq/XinXdFerzuutjXUGbpvAvJBt/23ISHvY5KfVgbFI=";
  };

  nativeBuildInputs = [
    gobject-introspection
    meson
    ninja
    pkg-config
    python3
    wayland-scanner
    wrapGAppsHook3
  ];

  buildInputs = [
    libdrm.dev
    libxkbcommon
    libinput
    glib
    gtk3
    gnome-desktop
    # For keybindings settings schemas
    mutter
    json-glib
    wayland
    finalAttrs.wlroots
    xorg.xcbutilwm
    gmobile
  ];

  postPatch = ''
    ln -s ${gvdb} subprojects/gvdb
  '';

  mesonFlags = [ "-Dembed-wlroots=disabled" ];

  # Patch wlroots to remove a check which crashes Phosh.
  # This patch can be found within the phoc source tree.
  wlroots = wlroots_0_19.overrideAttrs (old: {
    patches = (old.patches or [ ]) ++ [
      (stdenvNoCC.mkDerivation {
        name = "0001-Revert-layer-shell-error-on-0-dimension-without-anch.patch";
        inherit (finalAttrs) src;
        preferLocalBuild = true;
        allowSubstitutes = false;
        installPhase = "cp subprojects/packagefiles/wlroots/$name $out";
      })
    ];
  });

  passthru = {
    tests.phosh = nixosTests.phosh;
    tests.version = testers.testVersion {
      package = finalAttrs.finalPackage;
    };
    updateScript = nix-update-script { };
  };

  meta = with lib; {
    description = "Wayland compositor for mobile phones like the Librem 5";
    mainProgram = "phoc";
    homepage = "https://gitlab.gnome.org/World/Phosh/phoc";
    license = licenses.gpl3Plus;
    maintainers = with maintainers; [
      zhaofengli
      armelclo
    ];
    platforms = platforms.linux;
  };
})
