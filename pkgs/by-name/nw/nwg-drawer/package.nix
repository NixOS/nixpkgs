{
  lib,
  buildGoModule,
  cairo,
  fetchFromGitHub,
  gobject-introspection,
  gtk-layer-shell,
  gtk3,
  pkg-config,
  wrapGAppsHook3,
  xdg-utils,
}:

let
  pname = "nwg-drawer";
  version = "0.7.4";

  src = fetchFromGitHub {
    owner = "nwg-piotr";
    repo = "nwg-drawer";
    rev = "v${version}";
    hash = "sha256-yKRh2kAWg8GJjEJ/yCJ88JoJSgYR3c3RafeYU3z3pNU=";
  };

  vendorHash = "sha256-V0HYby/NKzShITctBllQea5nzbO/JGqTbdW1UttJSvw=";
in
buildGoModule {
  inherit
    pname
    version
    src
    vendorHash
    ;

  nativeBuildInputs = [
    gobject-introspection
    pkg-config
    wrapGAppsHook3
  ];

  buildInputs = [
    cairo
    gtk-layer-shell
    gtk3
  ];

  doCheck = false; # Too slow

  preInstall = ''
    mkdir -p $out/share/nwg-drawer
    cp -r desktop-directories drawer.css $out/share/nwg-drawer
  '';

  preFixup = ''
    # make xdg-open overrideable at runtime
    gappsWrapperArgs+=(
      --suffix PATH : ${xdg-utils}/bin
      --prefix XDG_DATA_DIRS : $out/share
    )
  '';

  meta = with lib; {
    description = "Application drawer for sway Wayland compositor";
    homepage = "https://github.com/nwg-piotr/nwg-drawer";
    changelog = "https://github.com/nwg-piotr/nwg-drawer/releases/tag/${src.rev}";
    license = with lib.licenses; [ agpl3Plus ];
    mainProgram = "nwg-drawer";
    maintainers = [ ];
    platforms = with lib.platforms; linux;
  };
}
