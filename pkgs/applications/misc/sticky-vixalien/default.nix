{ lib
, stdenv
, fetchFromGitHub
, fetchYarnDeps
, writeText
, appstream-glib
, desktop-file-utils
, fixup_yarn_lock
, gjs
, glib
, gtk4
, meson
, ninja
, pkg-config
, wrapGAppsHook4
, yarn
}:

stdenv.mkDerivation rec {
  pname = "sticky";
  version = "0.1.1";

  src = fetchFromGitHub {
    owner = "vixalien";
    repo = pname;
    rev = "v${version}";
    hash = "sha256-qyCXlU6aKjBr8tTo/es1WqVaz/B5O/O4clsmuHznJss=";
    fetchSubmodules = true;
  };

  nativeBuildInputs = [
    appstream-glib
    desktop-file-utils
    fixup_yarn_lock
    gjs
    glib
    gtk4
    meson
    ninja
    pkg-config
    wrapGAppsHook4
    yarn
  ];

  offlineCache = fetchYarnDeps {
    yarnLock = src + "/yarn.lock";
    hash = "sha256-HQC13KiLTP0akkH9hHyV/ephSwzPmnys1AavSNZ+8Oo=";
  };

  yarnrc = writeText ".yarnrc" "yarn-offline-mirror \"${offlineCache}\"";

  mesonFlags = [ "-Dyarnrc=${yarnrc}" ];

  preBuild = ''
    # meson's setup hook cd into build
    fixup_yarn_lock ../yarn.lock
  '';

  postFixup = ''
    # gjs uses the invocation name to add gresource files
    # - https://gitlab.gnome.org/GNOME/gjs/-/blob/6aca7b50785fa1638f144b17060870d721e3f65a/modules/script/package.js#L159
    # - https://gitlab.gnome.org/GNOME/gjs/-/blob/6aca7b50785fa1638f144b17060870d721e3f65a/modules/script/package.js#L37
    # To work around this, we manually set the the name as done in foliate
    # - https://github.com/NixOS/nixpkgs/blob/3bacde6273b09a21a8ccfba15586fb165078fb62/pkgs/applications/office/foliate/default.nix#L23
    sed -i "1 a imports.package._findEffectiveEntryPointName = () => 'com.vixalien.sticky';" $out/bin/.com.vixalien.sticky-wrapped
  '';

  meta = with lib; {
    homepage = "https://github.com/vixalien/sticky";
    description = "A simple sticky notes app";
    maintainers = with maintainers; [ linsui ];
    license = licenses.mit;
    platforms = platforms.linux;
  };
}
