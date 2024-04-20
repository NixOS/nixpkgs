{ lib
, stdenv
, fetchFromGitHub
, appstream-glib
, blueprint-compiler
, desktop-file-utils
, gobject-introspection
, meson
, ninja
, pkg-config
, wrapGAppsHook4
, gjs
, gtk4
, libadwaita
, libportal-gtk4
}:

stdenv.mkDerivation rec {
  pname = "junction";
  version = "1.7";

  src = fetchFromGitHub {
    owner = "sonnyp";
    repo = "junction";
    rev = "v${version}";
    sha256 = "sha256-qPseu2rzK6xp7eb/SrWK6fML/6xh4raP0MEreyZgqVI=";
    fetchSubmodules = true;
  };

  nativeBuildInputs = [
    appstream-glib
    blueprint-compiler
    desktop-file-utils
    gobject-introspection
    meson
    ninja
    pkg-config
    wrapGAppsHook4
  ];

  buildInputs = [
    gjs
    gtk4
    libadwaita
    libportal-gtk4
  ];

  postPatch = ''
    # gjs uses the invocation name to add gresource files
    # - https://gitlab.gnome.org/GNOME/gjs/-/blob/6aca7b50785fa1638f144b17060870d721e3f65a/modules/script/package.js#L159
    # - https://gitlab.gnome.org/GNOME/gjs/-/blob/6aca7b50785fa1638f144b17060870d721e3f65a/modules/script/package.js#L37
    # To work around this, we manually set the the name as done in foliate
    # - https://github.com/NixOS/nixpkgs/blob/3bacde6273b09a21a8ccfba15586fb165078fb62/pkgs/applications/office/foliate/default.nix#L23
    sed -i "1 a imports.package._findEffectiveEntryPointName = () => 're.sonny.Junction';" src/bin.js

    # /usr/bin/env is not accessible in build environment
    substituteInPlace troll/gjspack/bin/gjspack --replace "/usr/bin/env -S gjs" "${gjs}/bin/gjs"
  '';

  postInstall = ''
    # autoPatchShebangs does not like "/usr/bin/env -S <environment-setting> gjs -m"
    sed -i "1s|.*|#!/usr/bin/gjs -m|" $out/bin/re.sonny.Junction
  '';

  meta = with lib; {
    mainProgram = "re.sonny.Junction";
    description = "Choose the application to open files and links";
    homepage = "https://apps.gnome.org/en/app/re.sonny.Junction/";
    license = licenses.gpl3Only;
    maintainers = with maintainers; [ hqurve ];
    platforms = platforms.linux;
  };
}
