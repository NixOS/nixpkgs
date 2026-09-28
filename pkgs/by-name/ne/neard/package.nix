{
  stdenv,
  lib,
  fetchFromGitHub,
  autoreconfHook,
  autoconf-archive,
  gobject-introspection,
  pkg-config,
  wrapGAppsHook3,
  glib,
  dbus,
  libnl,
  python3Packages,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "neard";
  version = "0.20";

  outputs = [
    "out"
    "dev"
  ];

  src = fetchFromGitHub {
    owner = "linux-nfc";
    repo = "neard";
    tag = "v${finalAttrs.version}";
    hash = "sha256-Ty2jXaSuaI+ZuRBSpdh36Yi3V5nd8jGI43Jc9cLkMW4=";
  };

  postPatch = ''
    patchShebangs test/*
  '';

  nativeBuildInputs = [
    autoreconfHook
    autoconf-archive
    gobject-introspection
    pkg-config
    python3Packages.wrapPython
    wrapGAppsHook3
  ];

  dontWrapGApps = true;

  configureFlags = [
    "--enable-pie"
    "--enable-test"
    "--enable-tools"
    "--with-sysconfdir=/etc"
    "--with-systemdsystemunitdir=${placeholder "out"}/lib/systemd/system"
  ];

  buildInputs = [
    dbus
    glib
    libnl
  ];

  strictDeps = true;

  enableParallelBuilding = true;

  pythonPath = with python3Packages; [
    pygobject3
    dbus-python
  ];

  doCheck = true;

  preFixup = ''
    makeWrapperArgs+=("''${gappsWrapperArgs[@]}")
    wrapPythonProgramsIn "$out/lib/neard" "''${pythonPath[*]}"
  '';

  meta = {
    changelog = "https://github.com/linux-nfc/neard/blob/${finalAttrs.src.tag}/ChangeLog";
    description = "Near Field Communication manager";
    homepage = "https://01.org/linux-nfc";
    license = lib.licenses.gpl2Only;
    maintainers = [ ];
    platforms = lib.platforms.unix;
  };
})
