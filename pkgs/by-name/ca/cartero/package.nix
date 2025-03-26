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
}:
stdenv.mkDerivation (finalAttrs: {
  pname = "cartero";
  version = "0.1.5";

  src = fetchFromGitHub {
    owner = "danirod";
    repo = "cartero";
    tag = "v${finalAttrs.version}";
    hash = "sha256-1pSOyVGGl+G6mspdzzYP/BoQueVvAHTP6Vwqt6zL80c=";
  };

  cargoDeps = rustPlatform.fetchCargoVendor {
    inherit (finalAttrs) pname version src;
    hash = "sha256-qqxoP/T9de4w2wQJaCtQGRsoD+/dF7ir4iwYY69R+/I=";
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
    libxml2 # xmllint
  ];

  buildInputs = [
    libadwaita
    gtksourceview5
    openssl
  ];

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
    license = lib.licenses.gpl3Plus;
    mainProgram = "cartero";
    maintainers = with lib.maintainers; [
      aleksana
      amerino
    ];
    platforms = lib.platforms.linux;
  };
})
