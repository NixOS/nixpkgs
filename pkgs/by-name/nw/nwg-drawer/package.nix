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
  version = "0.6.4";

  src = fetchFromGitHub {
    owner = "nwg-piotr";
    repo = "nwg-drawer";
    rev = "v${version}";
    hash = "sha256-uctM2fi3lfSrvKSinkjAXD3bLyJOVC0DTyDoAKXgB54=";
  };

  vendorHash = "sha256-VW9K56pdzA6CAqyJ859WOCEtHTASW8lnQGuW1zBUJYw=";
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
    license = with lib.licenses; [ mit ];
    mainProgram = "nwg-drawer";
    maintainers = with lib.maintainers; [ ];
    platforms = with lib.platforms; linux;
  };
}
