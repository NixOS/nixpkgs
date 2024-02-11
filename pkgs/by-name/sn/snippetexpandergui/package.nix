{ lib
, buildGoModule
, fetchFromSourcehut
, makeWrapper
, wails
, scdoc
, installShellFiles
, xorg
, gtk3
, webkitgtk
, gsettings-desktop-schemas
, snippetexpanderd
}:

buildGoModule rec {
  inherit (snippetexpanderd) src version;

  pname = "snippetexpandergui";

  vendorHash = "sha256-iZfZdT8KlfZMVLQcYmo6EooIdsSGrpO/ojwT9Ft1GQI=";

  proxyVendor = true;

  modRoot = "cmd/snippetexpandergui";

  nativeBuildInputs = [
    makeWrapper
    wails
    scdoc
    installShellFiles
  ];

  buildInputs = [
    xorg.libX11
    gtk3
    webkitgtk
    gsettings-desktop-schemas
    snippetexpanderd
  ];

  ldflags = [
    "-s"
    "-w"
  ];

  tags = [
    "desktop"
    "production"
  ];

  postInstall = ''
    mv build/linux/share $out/share
    make man
    installManPage snippetexpandergui.1
  '';

  postFixup = ''
    wrapProgram $out/bin/snippetexpandergui \
      --prefix XDG_DATA_DIRS : ${gsettings-desktop-schemas}/share/gsettings-schemas/${gsettings-desktop-schemas.name}:${gtk3}/share/gsettings-schemas/${gtk3.name}
  '';

  meta = with lib; {
    description = "Your little expandable text snippet helper GUI";
    homepage = "https://snippetexpander.org";
    license = licenses.gpl2Plus;
    maintainers = with maintainers; [ ianmjones ];
    platforms = platforms.linux;
    mainProgram = "snippetexpandergui";
  };
}
