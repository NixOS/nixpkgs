{
  lib,
  stdenv,
  autoPatchelfHook,
  makeWrapper,
  zlib,
  openssl,
  cacert,
  fetchurl,
  hicolor-icon-theme,
  alsa-lib,
  libpulseaudio,
  libglvnd,
  xorg,
  glibc,
}:

stdenv.mkDerivation rec {
  pname = "occt";
  version = "15.0.13";

  src = fetchurl {
    url = "https://dl.ocbase.com/per/linux/occt-${version}-linux-x86_64.tar.gz";
    sha256 = "sha256-523ae1bf5a27e4b6465ddd6b62540680f7336fee21962e04f65cad019bb51e97";
  };

  nativeBuildInputs = [
    autoPatchelfHook
    makeWrapper
  ];

  buildInputs = [
    zlib
    openssl
    cacert
    alsa-lib
    libpulseaudio
    libglvnd
    xorg.libXext
    xorg.libXrender
    hicolor-icon-theme
    glibc
  ]
  ++ (with xorg; [
    libXcursor
    libXinerama
    libXi
    libXrandr
    libXfixes
    libXdamage
    libXcomposite
  ]);

  dontUnpack = true;

  installPhase = ''
        mkdir -p $out/opt/occt $out/bin $out/share/{applications,licenses/occt}

        install -m755 $src $out/opt/occt/occt

        touch $out/opt/occt/disable_update
        touch $out/opt/occt/use_home_config

        makeWrapper $out/opt/occt/occt $out/bin/occt \
          --prefix LD_LIBRARY_PATH : "${lib.makeLibraryPath buildInputs}" \
          --set DOTNET_SYSTEM_GLOBALIZATION_INVARIANT 1 \
          --set SSL_CERT_FILE "${cacert}/etc/ssl/certs/ca-bundle.crt" \
          --set SSL_CERT_DIR "${cacert}/etc/ssl/certs" \
          --set LOCALE_ARCHIVE "${glibc}/lib/locale/locale-archive" \
          --prefix XDG_DATA_DIRS : "${hicolor-icon-theme}/share"

        cat > $out/share/applications/occt.desktop <<EOF
    [Desktop Entry]
    Name=OCCT
    Comment=OverClock Checking Tool - CPU/GPU stress testing and monitoring
    Exec=$out/bin/occt
    Icon=occt
    Terminal=false
    Type=Application
    Categories=System;
    EOF

        echo "Proprietary OCCT License - Personal Edition" > $out/share/licenses/occt/LICENSE
  '';

  meta = with lib; {
    description = "OverClock Checking Tool - CPU/GPU stress testing and monitoring";
    homepage = "https://www.ocbase.com/";
    license = licenses.unfree;
    platforms = [ "x86_64-linux" ];
    maintainers = [ ];
  };
}
