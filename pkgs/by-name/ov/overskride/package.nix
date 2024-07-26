{ lib, fetchFromGitHub, rustPlatform, cargo, rustc, meson, ninja
, pkg-config, wrapGAppsHook4, desktop-file-utils, appstream-glib
, blueprint-compiler, dbus, gtk4, libadwaita, bluez, libpulseaudio }: let

owner = "kaii-lb";
name = "overskride";
version = "0.5.6";

in rustPlatform.buildRustPackage {

  pname = name;
  inherit version;

  src = fetchFromGitHub {
    inherit owner;
    repo = name;
    rev = "v${version}";
    hash = "sha256-syQzHHT0s15oj8Yl2vhgyXlPI8UxOqIXGDqFeUc/dJQ=";
  };

  cargoHash = "sha256-NEsqVfKZqXSLieRO0BvQGdggmXXYO15qVhbfgAFATPc=";

  nativeBuildInputs = [
    pkg-config
    wrapGAppsHook4
    desktop-file-utils
    appstream-glib
    blueprint-compiler
    meson
    ninja
    cargo
    rustc
  ];

  buildInputs = [ dbus gtk4 libadwaita bluez libpulseaudio ];

  buildPhase = ''
    runHook preBuild

    meson setup build --prefix $out && cd build
    meson compile && meson devenv

    runHook postBuild
  '';

  # The "Validate appstream file" test fails.
  # TODO: This appears to have been fixed upstream
  # so checks should be enabled with the next version.
  doCheck = false;

  preFixup = ''
    glib-compile-schemas $out/share/gsettings-schemas/${name}-${version}/glib-2.0/schemas
  '';

  meta = with lib; {
    description =
      "A Bluetooth and Obex client that is straight to the point, DE/WM agnostic, and beautiful";
    homepage = "https://github.com/${owner}/${name}";
    changelog = "https://github.com/${owner}/${name}/blob/v${version}/CHANGELOG.md";
    license = licenses.gpl3Only;
    mainProgram = name;
    maintainers = with maintainers; [ mrcjkb ];
    platforms = platforms.linux;
  };

}
