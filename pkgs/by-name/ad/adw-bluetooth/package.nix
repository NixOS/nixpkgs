{
  stdenv,
  lib,
  fetchFromGitHub,
  buildGoModule,
  meson,
  ninja,
  pkg-config,
  blueprint-compiler,
  typescript,
  desktop-file-utils,
  wrapGAppsHook4,
  gjs,
  libadwaita,
}:

let
  version = "1.1.0";

  src = fetchFromGitHub {
    owner = "ezratweaver";
    repo = "adw-bluetooth";
    tag = version;
    hash = "sha256-h3cHtecwBsx3j33qXVn/zaq4FZext71P7flzunCHqHg=";
  };

  daemon = buildGoModule {
    pname = "adw-bluetooth-daemon";
    inherit version;
    src = src + "/daemon";
    vendorHash = "sha256-7tiSwNhq6e4LEh4lUkfh2i4tEdWWL6TxQpYYwYKsfog=";
  };
in
stdenv.mkDerivation (finalAttrs: {
  pname = "adw-bluetooth";
  inherit version src;

  nativeBuildInputs = [
    meson
    ninja
    pkg-config
    blueprint-compiler
    typescript
    desktop-file-utils
    wrapGAppsHook4
  ];

  buildInputs = [
    gjs
    libadwaita
  ];

  mesonFlags = [ "-Dbuild_daemon=false" ];

  postInstall = ''
    mkdir -p $out/libexec
    ln -s ${daemon}/bin/daemon $out/libexec/adw-bluetooth-daemon
  '';

  meta = {
    description = "GNOME Inspired LibAdwaita Bluetooth Applet";
    homepage = "https://github.com/ezratweaver/adw-bluetooth";
    license = lib.licenses.gpl3Only;
    platforms = lib.platforms.linux;
    maintainers = with lib.maintainers; [ ezratweaver ];
  };
})
