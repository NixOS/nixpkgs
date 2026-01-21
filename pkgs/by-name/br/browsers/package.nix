{
  lib,
  rustPlatform,
  fetchFromGitHub,
  pkg-config,
  wrapGAppsHook3,
  atk,
  cairo,
  gdk-pixbuf,
  glib,
  gtk3,
  pango,
}:

rustPlatform.buildRustPackage (finalAttrs: {
  pname = "browsers";
  version = "0.7.3";

  src = fetchFromGitHub {
    owner = "Browsers-software";
    repo = "browsers";
    tag = finalAttrs.version;
    hash = "sha256-QrIE9buG46JDxGFI6tjxzMizic82Az61MgMhKU854bY=";
  };

  cargoHash = "sha256-JZoc5EwOXgv50LblYjEW8tsD4roJ6uZYuCbVzXdaKSY=";

  nativeBuildInputs = [
    pkg-config
    wrapGAppsHook3
  ];

  buildInputs = [
    atk
    cairo
    gdk-pixbuf
    glib
    gtk3
    pango
  ];

  postInstall = ''
    install -m 444 \
        -D extra/linux/dist/software.Browsers.template.desktop \
        -t $out/share/applications
    mv $out/share/applications/software.Browsers.template.desktop $out/share/applications/software.Browsers.desktop
    substituteInPlace \
        $out/share/applications/software.Browsers.desktop \
        --replace-fail 'Exec=€ExecCommand€' 'Exec=${finalAttrs.pname} %u'
    cp -r resources $out
    for size in 16 32 128 256 512; do
      install -m 444 \
          -D resources/icons/"$size"x"$size"/software.Browsers.png \
          -t $out/share/icons/hicolor/"$size"x"$size"/apps
    done
  '';

  meta = {
    description = "Open the right browser at the right time";
    homepage = "https://browsers.software";
    changelog = "https://github.com/Browsers-software/browsers/blob/${finalAttrs.version}/CHANGELOG.md";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ ravenz46 ];
    mainProgram = "browsers";
  };
})
