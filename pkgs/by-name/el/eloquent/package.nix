{
  lib,
  stdenv,
  fetchFromGitHub,
  appstream,
  blueprint-compiler,
  desktop-file-utils,
  gobject-introspection,
  meson,
  ninja,
  pkg-config,
  wrapGAppsHook4,
  gjs,
  gtk4,
  libadwaita,
  libsoup_3,
  libportal-gtk4,
  nix-update-script,
}:

stdenv.mkDerivation rec {
  pname = "eloquent";
  version = "1.2";

  src = fetchFromGitHub {
    owner = "sonnyp";
    repo = "Eloquent";
    rev = "v${version}";
    hash = "sha256-I4AQZl1zoZPhOwDR1uYNJTMRq5vQHPvyimC8OUAe+vY=";
    fetchSubmodules = true;
  };

  nativeBuildInputs = [
    appstream
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
    libsoup_3
    libportal-gtk4
  ];

  postPatch = ''
    # gjs uses the invocation name to add gresource files
    # - https://gitlab.gnome.org/GNOME/gjs/-/blob/6aca7b50785fa1638f144b17060870d721e3f65a/modules/script/package.js#L159
    # - https://gitlab.gnome.org/GNOME/gjs/-/blob/6aca7b50785fa1638f144b17060870d721e3f65a/modules/script/package.js#L37
    # To work around this, we manually set the the name as done in foliate
    # - https://github.com/NixOS/nixpkgs/blob/3bacde6273b09a21a8ccfba15586fb165078fb62/pkgs/applications/office/foliate/default.nix#L23
    sed -i "1 a imports.package._findEffectiveEntryPointName = () => 're.sonny.Eloquent';" src/bin.js

    # /usr/bin/env is not accessible in build environment
    substituteInPlace troll/gjspack/bin/gjspack --replace "/usr/bin/env -S gjs" "${gjs}/bin/gjs"
  '';

  postInstall = ''
    # autoPatchShebangs does not like "/usr/bin/env -S <environment-setting> gjs -m"
    sed -i "1s|.*|#!/usr/bin/gjs -m|" $out/bin/re.sonny.Eloquent
  '';

  passthru = {
    updateScript = nix-update-script { };
  };

  meta = with lib; {
    mainProgram = "re.sonny.Eloquent";
    description = "Your proofreading assistant";
    homepage = "https://github.com/sonnyp/Eloquent";
    license = licenses.gpl3Only;
    maintainers = with maintainers; [ reputable2772 ];
    platforms = platforms.linux;
  };
}
