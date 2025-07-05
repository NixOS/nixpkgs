{
  lib,
  stdenv,
  fetchFromGitHub,
  cmake,
  pkg-config,

  dbus,
  dbus-glib,
  glib
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "mce";
  version = "1.10.9";

  src = fetchFromGitHub {
    owner = "maemo-leste";
    repo = "mce";
    rev = "refs/tags/${finalAttrs.version}";
    hash = "sha256-W0seXFNlUq1+XtaeXQUzGXDnKgUQC45gryCF0wb9bBk=";
  };

  prePatch = ''
    substituteInPlace CMakeLists.txt \
      --replace-fail "/etc/mce" "???"
  '';

  nativeBuildInputs = [
    cmake
    pkg-config
  ];

  buildInputs = [
    dbus
    dbus-glib
    glib
  ];

  meta = {
    maintainers = with lib.maintainers; [ simganificient ];
    license = lib.licenses.gpl2;
  };
})
