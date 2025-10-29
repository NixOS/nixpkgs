{
  lib,
  stdenv,
  fetchFromGitLab,
  meson,
  ninja,
  pkg-config,
  glib,
  python3,
  help2man,
  bash-completion,
  bash,
  buildPackages,
  withIntrospection ?
    lib.meta.availableOn stdenv.hostPlatform gobject-introspection
    && stdenv.hostPlatform.emulatorAvailable buildPackages,
  withDocs ? stdenv.hostPlatform == stdenv.buildPlatform,
  gobject-introspection,
}:

stdenv.mkDerivation rec {
  pname = "libmbim";
  version = "1.32.0";

  outputs = [
    "out"
    "dev"
  ]
  ++ lib.optionals withDocs [ "man" ];

  src = fetchFromGitLab {
    domain = "gitlab.freedesktop.org";
    owner = "mobile-broadband";
    repo = "libmbim";
    rev = version;
    hash = "sha256-+4INXuH2kbKs9C6t4bOJye7yyfYH/BLukmgDVvXo+u0=";
  };

  mesonFlags = [
    "-Dudevdir=${placeholder "out"}/lib/udev"
    (lib.mesonBool "introspection" withIntrospection)
    (lib.mesonBool "man" withDocs)
  ];

  strictDeps = true;

  nativeBuildInputs = [
    meson
    ninja
    pkg-config
    python3
  ]
  ++ lib.optionals withDocs [
    help2man
  ]
  ++ lib.optionals withIntrospection [
    gobject-introspection
  ];

  buildInputs = [
    glib
    bash-completion
    bash
  ];

  doCheck = true;

  postPatch = ''
    patchShebangs \
      build-aux/mbim-codegen/mbim-codegen
  '';

  meta = {
    homepage = "https://www.freedesktop.org/wiki/Software/libmbim/";
    description = "Library for talking to WWAN modems and devices which speak the Mobile Interface Broadband Model (MBIM) protocol";
    changelog = "https://gitlab.freedesktop.org/mobile-broadband/libmbim/-/raw/${version}/NEWS";
    teams = [ lib.teams.freedesktop ];
    platforms = lib.platforms.linux;
    license = lib.licenses.gpl2Plus;
  };
}
