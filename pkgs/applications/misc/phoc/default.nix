{ lib
, stdenv
, stdenvNoCC
, fetchurl
, meson
, ninja
, pkg-config
, python3
, wrapGAppsHook3
, libinput
, gobject-introspection
, gnome
, gnome-desktop
, glib
, gtk3
, json-glib
, wayland
, libdrm
, libxkbcommon
, wlroots
, xorg
, directoryListingUpdater
, nixosTests
, testers
, cmake
, gmobile
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "phoc";
  version = "0.40.1";

  src = fetchurl {
    # This tarball includes the meson wrapped subproject 'gmobile'.
    url = with finalAttrs; "https://sources.phosh.mobi/releases/${pname}/${pname}-${version}.tar.xz";
    hash = "sha256-y8ZSWKANy58kqG7YIWo2Oh0NEbl39HmHBIzPeHTKPrk=";
  };

  nativeBuildInputs = [
    gobject-introspection
    meson
    ninja
    pkg-config
    python3
    wrapGAppsHook3
    cmake
  ];

  buildInputs = [
    libdrm.dev
    libxkbcommon
    libinput
    glib
    gtk3
    gnome-desktop
    # For keybindings settings schemas
    gnome.mutter
    json-glib
    wayland
    finalAttrs.wlroots
    xorg.xcbutilwm
    gmobile
  ];

  mesonFlags = ["-Dembed-wlroots=disabled"];

  # Patch wlroots to remove a check which crashes Phosh.
  # This patch can be found within the phoc source tree.
  wlroots = wlroots.overrideAttrs (old: {
    patches = (old.patches or []) ++ [
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
    updateScript = directoryListingUpdater { };
  };

  meta = with lib; {
    description = "Wayland compositor for mobile phones like the Librem 5";
    mainProgram = "phoc";
    homepage = "https://gitlab.gnome.org/World/Phosh/phoc";
    license = licenses.gpl3Plus;
    maintainers = with maintainers; [ masipcat zhaofengli ];
    platforms = platforms.linux;
  };
})
