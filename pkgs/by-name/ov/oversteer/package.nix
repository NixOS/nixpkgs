{ lib, stdenv, fetchFromGitHub, pkg-config, gettext, python3, python3Packages
, meson, ninja, udev, appstream, appstream-glib, desktop-file-utils, gtk3
, wrapGAppsHook3, gobject-introspection, bash, }:
let
  python = python3.withPackages (p:
    with p; [
      pygobject3
      pyudev
      pyxdg
      evdev
      matplotlib
      scipy
      gtk3
      pygobject3
    ]);

  version = "0.8.1";
in stdenv.mkDerivation {
  inherit version;

  pname = "oversteer";

  src = fetchFromGitHub {
    owner = "berarma";
    repo = "oversteer";
    rev = version;
    sha256 = "sha256-J23fgEDkfZMjVEYHaSPbU9zh5CQFjPmqMsm09VybBv8=";
  };

  buildInputs = [ bash gtk3 ];

  nativeBuildInputs = [
    pkg-config
    gettext
    python
    wrapGAppsHook3
    gobject-introspection
    meson
    udev
    ninja
    appstream
    appstream-glib
    desktop-file-utils
  ];

  dontUseCmakeConfigure = true;

  propagatedBuildInputs = [ python gtk3 python3Packages.pygobject3 ];

  mesonFlags = [
    "--prefix"
    (placeholder "out")
    "-Dudev_rules_dir=${placeholder "out"}/lib/udev/rules.d/"
  ];

  preFixup = ''
    gappsWrapperArgs+=(
      --prefix XDG_DATA_DIRS : "${gtk3}/share/gsettings-schemas/${gtk3.name}"
    )
  '';

  postInstall = ''
    substituteInPlace $out/lib/udev/rules.d/* \
      --replace /bin/sh ${bash}/bin/sh
  '';

  patches = [ ];

  meta = with lib; {
    homepage = "https://github.com/berarma/oversteer";
    changelog = "https://github.com/berarma/oversteer/releases/tag/${version}";
    description = "Steering Wheel Manager for Linux";
    mainProgram = "oversteer";
    license = licenses.gpl3Plus;
    maintainers = [ maintainers.srounce ];
    platforms = platforms.unix;
  };
}
