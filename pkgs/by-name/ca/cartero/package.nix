{
  lib,
  stdenv,
  fetchFromGitHub,
  rustPlatform,
  meson,
  ninja,
  pkg-config,
  cargo,
  rustc,
  blueprint-compiler,
  wrapGAppsHook4,
  desktop-file-utils,
  libxml2,
  libadwaita,
  gtksourceview5,
  openssl,
  python313,
  gtk4,
  shared-mime-info,
  glib,
  hicolor-icon-theme,
  pango,
}:
stdenv.mkDerivation (finalAttrs: {
  pname = "cartero";
  version = "25.0";

  src = fetchFromGitHub {
    owner = "danirod";
    repo = "cartero";
    tag = "v${finalAttrs.version}";
    hash = "sha256-XUf5Gfg+ZyyzcbZYSxFTM4ot84FF2bgGJoQg2ZAIZ3g=";
  };

  cargoDeps = rustPlatform.fetchCargoVendor {
    inherit (finalAttrs) pname version src;
    hash = "sha256-T1OR8okOm5hFYsRLqqNYhP39Av/veHnoomkC29/JyAY=";
  };

  nativeBuildInputs = [
    meson
    ninja
    pkg-config
    rustPlatform.cargoSetupHook
    cargo
    rustc
    blueprint-compiler
    wrapGAppsHook4
    desktop-file-utils
    libxml2
    python313
    gtk4
    shared-mime-info
    glib
    hicolor-icon-theme
  ];

  buildInputs = [
    libadwaita
    gtksourceview5
    openssl
    pango
    libadwaita
  ];

  postPatch = ''
    patchShebangs --build build-aux/gen-version.py
  '';

  meta = {
    description = "Make HTTP requests and test APIs";
    longDescription = ''
      Cartero is a graphical HTTP client that can be used
      as a developer tool to test web APIs and perform all
      kind of HTTP requests to web servers. It is compatible
      with any REST, SOAP or XML-RPC API and it supports
      multiple request methods as well as attaching body
      payloads to compatible requests.
    '';
    homepage = "https://cartero.danirod.es";
    changelog = "https://github.com/danirod/cartero/releases";
    license = lib.licenses.gpl3Plus;
    mainProgram = "cartero";
    maintainers = with lib.maintainers; [
      aleksana
      amerino
    ];
    platforms = lib.platforms.linux;
  };
})
