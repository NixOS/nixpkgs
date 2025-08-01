{
  lib,
  stdenv,
  fetchurl,
  pkg-config,
  meson,
  ninja,
  dbus,
  libgcrypt,
  pam,
  python3,
  glib,
  libxslt,
  gettext,
  gcr,
  libcap_ng,
  libselinux,
  p11-kit,
  wrapGAppsNoGuiHook,
  docbook-xsl-nons,
  docbook_xml_dtd_43,
  gnome,
  useWrappedDaemon ? true,
}:

stdenv.mkDerivation rec {
  pname = "gnome-keyring";
  version = "48.0";

  outputs = [
    "out"
    "dev"
  ];

  src = fetchurl {
    url = "mirror://gnome/sources/gnome-keyring/${lib.versions.major version}/gnome-keyring-${version}.tar.xz";
    hash = "sha256-8gUYySDp6j+cm4tEvoxQ2Nf+7NDdViSWD3e9LKT7650=";
  };

  nativeBuildInputs = [
    pkg-config
    meson
    ninja
    gettext
    glib # for glib-genmarshal
    libxslt
    docbook-xsl-nons
    docbook_xml_dtd_43
    wrapGAppsNoGuiHook
  ];

  buildInputs = [
    glib
    libgcrypt
    pam
    libcap_ng
    libselinux
    gcr
    p11-kit
  ];

  nativeCheckInputs = [
    dbus
    python3
  ];

  mesonFlags = [
    # installation directories
    "-Dpkcs11-config=${placeholder "out"}/etc/pkcs11" # todo: this should probably be /share/p11-kit/modules
    "-Dpkcs11-modules=${placeholder "out"}/lib/pkcs11"
    # TODO: enable socket activation
    "-Dsystemd=disabled"
  ];

  # Tends to fail non-deterministically.
  # - https://github.com/NixOS/nixpkgs/issues/55293
  # - https://github.com/NixOS/nixpkgs/issues/51121
  # - At least “gnome-keyring:gkm::xdg-store / xdg-trust” is still flaky on 48.beta.
  doCheck = false;
  strictDeps = true;

  checkPhase = ''
    runHook postCheck

    export HOME=$(mktemp -d)
    dbus-run-session \
      --config-file=${dbus}/share/dbus-1/session.conf \
      meson test --print-errorlogs

    runHook preCheck
  '';

  # Use wrapped gnome-keyring-daemon with cap_ipc_lock=ep
  postFixup = lib.optionalString useWrappedDaemon ''
    files=($out/etc/xdg/autostart/* $out/share/dbus-1/services/*)

    for file in ''${files[*]}; do
      substituteInPlace $file \
        --replace "$out/bin/gnome-keyring-daemon" "/run/wrappers/bin/gnome-keyring-daemon"
    done
  '';

  passthru = {
    updateScript = gnome.updateScript {
      packageName = "gnome-keyring";
    };
  };

  meta = {
    description = "Collection of components in GNOME that store secrets, passwords, keys, certificates and make them available to applications";
    homepage = "https://gitlab.gnome.org/GNOME/gnome-keyring";
    changelog = "https://gitlab.gnome.org/GNOME/gnome-keyring/-/blob/${version}/NEWS?ref_type=tags";
    license = [
      # Most of the code (some is 2Plus)
      lib.licenses.lgpl21Plus
      # Some stragglers
      lib.licenses.gpl2Plus
    ];
    teams = [ lib.teams.gnome ];
    platforms = lib.platforms.linux;
  };
}
