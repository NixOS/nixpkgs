{
  lib,
  python3,
  fetchFromSourcehut,
  fetchurl,
  desktop-file-utils,
  glib,
  gobject-introspection,
  gtk3,
  libhandy,
  librsvg,
  meson,
  ninja,
  pkg-config,
  wrapGAppsHook3,
}:

python3.pkgs.buildPythonApplication (finalAttrs: {
  pname = "numberstation";
  version = "1.5.0";

  pyproject = false;

  src = fetchFromSourcehut {
    owner = "~martijnbraam";
    repo = "numberstation";
    tag = finalAttrs.version;
    hash = "sha256-N8hTXlJcekg/+dCK/tp2EhbNBtj8n9K3LHURRI5ruQQ=";
  };

  patches = [
    (fetchurl {
      url = "https://src.fedoraproject.org/rpms/numberstation/raw/05cb9e58d879cd9d224862bb72c373374de63943/f/0001-Fix-if-statement-after-b32decode-removal.patch";
      hash = "sha256-grTSKdXl1WIK+n4rOe/g4lczc8eIuCU1ZqHI1VNkJ8w=";
    })
  ];

  postPatch = ''
    patchShebangs build-aux/meson
  '';

  nativeBuildInputs = [
    desktop-file-utils
    glib
    gtk3
    gobject-introspection
    meson
    ninja
    pkg-config
    wrapGAppsHook3
  ];

  buildInputs = [
    gtk3
    libhandy
    librsvg
  ];

  propagatedBuildInputs = with python3.pkgs; [
    keyring
    pygobject3
    pyotp
  ];

  dontWrapGApps = true;

  preFixup = ''
    makeWrapperArgs+=("''${gappsWrapperArgs[@]}")
  '';

  meta = {
    changelog = "https://git.sr.ht/~martijnbraam/numberstation/refs/${finalAttrs.version}";
    description = "TOTP Authentication application for mobile";
    mainProgram = "numberstation";
    homepage = "https://sr.ht/~martijnbraam/numberstation/";
    license = lib.licenses.gpl3Only;
    maintainers = with lib.maintainers; [ dotlambda ];
  };
})
