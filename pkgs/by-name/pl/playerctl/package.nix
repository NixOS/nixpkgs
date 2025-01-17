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

stdenv.mkDerivation rec {
  pname = "playerctl";
  version = "2.4.1";

  src = fetchFromGitHub {
    owner = "acrisci";
    repo = "playerctl";
    rev = "v${version}";
    sha256 = "sha256-OiGKUnsKX0ihDRceZoNkcZcEAnz17h2j2QUOSVcxQEY=";
  };

  nativeBuildInputs =
    [
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

  meta = with lib; {
    description = "Command-line utility and library for controlling media players that implement MPRIS";
    homepage = "https://github.com/acrisci/playerctl";
    license = licenses.lgpl3;
    platforms = platforms.unix;
    maintainers = with maintainers; [ puffnfresh ];
    broken = stdenv.hostPlatform.isDarwin;
    mainProgram = "playerctl";
  };
}
