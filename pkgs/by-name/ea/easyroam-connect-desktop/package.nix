{
  stdenv,
  lib,
  fetchurl,
  autoPatchelfHook,
  glib,
  gtk3,
  pango,
  cairo,
  harfbuzz,
  networkmanager,
  libsecret,
  libsoup_3,
  webkitgtk_4_1,
  glib-networking,
  wrapGAppsHook3,
}:
stdenv.mkDerivation rec {
  pname = "easyroam-connect-desktop";
  version = "1.3.5";

  src = fetchurl {
    url = "http://packages.easyroam.de/repos/easyroam-desktop/pool/main/e/easyroam-desktop/easyroam_connect_desktop-${version}+${version}-linux.deb";
    hash = "sha256-TRzEPPjsD1+eSuElvbTV4HJFfwfS+EH+r/OhdMP8KG0=";
  };

  dontConfigure = true;
  dontBuild = true;

  nativeBuildInputs = [
    autoPatchelfHook
    wrapGAppsHook3
  ];

  buildInputs = [
    glib
    gtk3
    pango
    cairo
    harfbuzz
    libsecret
    networkmanager
    webkitgtk_4_1
    libsoup_3
    glib-networking
  ];

  unpackPhase = ''
    ar p $src data.tar.xz | tar xJ
  '';

  installPhase = ''
    runHook preInstall

    mkdir -p $out
    cp -r usr/share $out/share

    mkdir -p $out/bin
    ln -s $out/share/easyroam_connect_desktop/easyroam_connect_desktop $out/bin/easyroam_connect_desktop

    runHook postInstall
  '';

  meta = with lib; {
    description = "Manage and install your easyroam WiFi profiles";
    mainProgram = "easyroam_connect_desktop";
    longDescription = ''
      Using this software you can easily connect your device to eduroam® by simply logging in with your DFN-AAI account.
    '';
    homepage = "https://easyroam.de";
    license = licenses.unfree;
    maintainers = with maintainers; [
      shadows_withal
      MarchCraft
    ];
    platforms = [ "x86_64-linux" ];
  };
}
