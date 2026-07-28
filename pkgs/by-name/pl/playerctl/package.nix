{
  lib,
  stdenv,
  buildPackages,
  docbook_xsl,
  fetchFromGitHub,
  glib,
  gobject-introspection,
  gtk-doc,
  meson,
  mesonEmulatorHook,
  ninja,
  pkg-config,
  withDocs ? stdenv.hostPlatform.emulatorAvailable buildPackages,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "playerctl";
  version = "2.4.1";

  src = fetchFromGitHub {
    owner = "acrisci";
    repo = "playerctl";
    rev = "v${finalAttrs.version}";
    sha256 = "sha256-OiGKUnsKX0ihDRceZoNkcZcEAnz17h2j2QUOSVcxQEY=";
  };

  # macOS's ld64 has no --version-script, so translate the data/playerctl.syms
  # filter to an -exported_symbols_list to keep the same symbols exported on darwin
  postPatch = lib.optionalString stdenv.hostPlatform.isDarwin ''
    printf '%s\n' '_Playerctl*' '_PLAYERCTL*' '_playerctl_*' '_pctl_*' > data/playerctl.syms
    substituteInPlace playerctl/meson.build \
      --replace-fail '--version-script' '-exported_symbols_list'
  '';

  nativeBuildInputs = [
    docbook_xsl
    gobject-introspection
    gtk-doc
    meson
    ninja
    pkg-config
  ]
  ++ lib.optionals (withDocs && !stdenv.buildPlatform.canExecute stdenv.hostPlatform) [
    mesonEmulatorHook
  ];
  buildInputs = [ glib ];

  mesonFlags = [
    (lib.mesonBool "bash-completions" true)
    (lib.mesonBool "zsh-completions" true)
    (lib.mesonBool "gtk-doc" withDocs)
  ];

  meta = {
    description = "Command-line utility and library for controlling media players that implement MPRIS";
    homepage = "https://github.com/acrisci/playerctl";
    license = lib.licenses.lgpl3;
    platforms = lib.platforms.unix;
    maintainers = with lib.maintainers; [
      puffnfresh
      anish
    ];
    mainProgram = "playerctl";
  };
})
