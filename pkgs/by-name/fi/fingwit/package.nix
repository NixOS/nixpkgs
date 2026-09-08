{
  fetchFromGitHub,
  gettext,
  glib,
  gobject-introspection,
  gtk3,
  lib,
  meson,
  ninja,
  pam,
  pkg-config,
  python3,
  python3Packages,
  wrapGAppsHook3,
  xapp,
}:
python3Packages.buildPythonApplication (finalAttrs: {
  pname = "fingwit";
  version = "1.0.8";
  format = "other";

  __structuredAttrs = true;

  src = fetchFromGitHub {
    owner = "xapp-project";
    repo = "fingwit";
    tag = finalAttrs.version;
    hash = "sha256-Pyyl79cwKHAfir8uQ4nzjcxc6yz50EbX6VCJDBNLJTs=";
  };

  nativeBuildInputs = [
    meson
    ninja
    gettext
    wrapGAppsHook3
    gobject-introspection
    pkg-config
  ];

  buildInputs = [
    gtk3
    xapp
    glib
    pam
  ];

  dependencies = with python3Packages; [
    pygobject3
    setproctitle
    python-pam
  ];

  patches = [ ./0001-check-all-pam-services-for-fprintd.patch ];

  postPatch = ''
    patchShebangs data/meson_install_schemas.py

    substituteInPlace pam_fingwit.py \
      --replace-fail "import PAM" "import pam" \
      --replace-fail "PAM." "pam."

    substituteInPlace pam_fingwit.c \
      --replace-fail '"python3"' '"${lib.getExe python3}"'
  '';

  postInstall = ''
    # Fix hard-coded non-FHS paths
    substituteInPlace $out/bin/fingwit \
      --replace-fail "/usr/share" "$out/share"

    # Use standard freedesktop icon names
    substituteInPlace $out/share/fingwit/fingwit.ui \
      --replace-fail "xsi-fingerprint-symbolic" "auth-fingerprint-symbolic" \
      --replace-fail "xsi-open-menu-symbolic" "open-menu-symbolic"
    substituteInPlace $out/bin/fingwit \
      --replace-fail "xsi-fingerprint-symbolic" "auth-fingerprint-symbolic"
  '';

  meta = {
    description = "Fingerprint configuration tool (XApp)";
    homepage = "https://github.com/xapp-project/fingwit";
    license = lib.licenses.gpl3;
    platforms = lib.platforms.linux;
    mainProgram = "fingwit";
    maintainers = with lib.maintainers; [
      kajusnau
    ];
  };
})
