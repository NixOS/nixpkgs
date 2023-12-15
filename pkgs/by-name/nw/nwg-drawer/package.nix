{ lib
, buildGoModule
, cairo
, fetchFromGitHub
, gobject-introspection
, gtk-layer-shell
, gtk3
, pkg-config
, wrapGAppsHook
, xdg-utils
}:

let
  pname = "nwg-drawer";
  version = "0.4.3";

  src = fetchFromGitHub {
    owner = "nwg-piotr";
    repo = "nwg-drawer";
    rev = "v${version}";
    hash = "sha256-1iylXR3WP39E/0L/vBe5LxXOKV+KisgUr2rxBEHahMo=";
  };

  vendorHash = "sha256-8s8+ukMQpciQmKt77fNE7r+3cm/UDxO8VtkrNYdKhM8=";
in
buildGoModule {
  inherit pname version src vendorHash;

  nativeBuildInputs = [
    gobject-introspection
    pkg-config
    wrapGAppsHook
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
    license = with lib.licenses; [ mit ];
    mainProgram = "nwg-drawer";
    maintainers = with lib.maintainers; [ AndersonTorres ];
    platforms = with lib.platforms; linux;
  };
}
