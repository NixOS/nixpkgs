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
}:
stdenv.mkDerivation rec {
  pname = "easyroam-connect-desktop";
  version = "1.3.2";

  src = fetchurl {
    url = "http://packages.easyroam.de/repos/easyroam-desktop/pool/main/e/easyroam-desktop/easyroam_connect_desktop-${version}+${version}-linux.deb";
    hash = "sha256-XGPSP4yPNHO+Hj/mneDJZVcgb48aOe5TrI0f+MXac/E=";
  };

  dontConfigure = true;
  dontBuild = true;

  nativeBuildInputs = [ autoPatchelfHook ];

  buildInputs = [
    glib
    gtk3
    pango
    cairo
    harfbuzz
    libsecret
    networkmanager
  ];

  unpackPhase = ''
    ar p $src data.tar.xz | tar xJ
  '';

  installPhase = ''
    runHook preInstall

    mkdir -p $out/share
    mv usr/share $out

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
    maintainers = with maintainers; [ shadows_withal ];
    platforms = [ "x86_64-linux" ];
  };
}
