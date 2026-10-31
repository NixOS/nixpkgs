{
  lib,
  stdenv,
  fetchurl,
  autoPatchelfHook,
  makeBinaryWrapper,
  dpkg,
  gjs,
  glib,
  nss,
  nspr,
  at-spi2-atk,
  cups,
  libdrm,
  gtk3,
  pango,
  cairo,
  libgbm,
  expat,
  libxkbcommon,
  alsa-lib,
  libnotify,
  mesa,
  vulkan-loader,
  systemd,
  coreutils,
  procps,
  which,
  iputils,
  libx11,
  libxcb,
  libxcomposite,
  libxdamage,
  libxext,
  libxfixes,
  libxrandr,
  libxtst,
}:
let

  deps = [
    glib
    nss
    nspr
    at-spi2-atk
    cups
    libdrm
    gtk3
    pango
    cairo
    libgbm
    expat
    libxkbcommon
    alsa-lib
    libnotify
    mesa
    vulkan-loader
    libx11
    libxcb
    libxcomposite
    libxdamage
    libxext
    libxfixes
    libxrandr
    libxtst
  ];

in
stdenv.mkDerivation (finalAttrs: {
  pname = "surfshark";
  version = "3.9.0";

  src = fetchurl {
    url = "https://ocean.surfshark.com/debian/pool/main/s/surfshark_${finalAttrs.version}_amd64.deb";
    hash = "sha256-1GdtzTQt4wIg+8rABNHq1kyGE2rf2cZTqxfQqRIIkao=";
  };

  nativeBuildInputs = [
    autoPatchelfHook
    dpkg
    gjs
    makeBinaryWrapper
  ];

  buildInputs = deps;

  dontConfigure = true;
  dontBuild = true;

  installPhase = ''
    runHook preInstall

    mkdir -p $out/{bin,share/surfshark,lib/systemd/system,lib/systemd/user}

    # App bundle
    cp -r opt/Surfshark/. $out/share/surfshark/

    # Desktop entry, icons, docs
    cp -r usr/share/. $out/share/

    # OpenVPN certs
    mkdir -p $out/etc/openvpn/client/surfshark
    cp -r etc/openvpn/client/surfshark/. $out/etc/openvpn/client/surfshark/

    # systemd service units — patch hardcoded /opt/Surfshark paths
    substitute usr/lib/systemd/system/surfsharkd2.service $out/lib/systemd/system/surfsharkd2.service \
      --replace-fail "/opt/Surfshark" "$out/share/surfshark"
    substitute usr/lib/systemd/user/surfsharkd.service $out/lib/systemd/user/surfsharkd.service \
      --replace-fail "/opt/Surfshark" "$out/share/surfshark"

    # Make daemon scripts executable
    chmod +x $out/share/surfshark/resources/dist/resources/surfsharkd*.js

    # Patch shebangs
    patchShebangs $out/share/surfshark/resources/dist/resources

    # Fix .desktop Exec path
    substituteInPlace $out/share/applications/surfshark.desktop \
      --replace-fail "Exec=/opt/Surfshark/surfshark" "Exec=$out/bin/surfshark"

    makeBinaryWrapper $out/share/surfshark/surfshark $out/bin/surfshark \
      --add-flags "--no-sandbox" \
      --prefix PATH : ${
        lib.makeBinPath [
          coreutils
          procps
          which
          iputils
        ]
      } \

    runHook postInstall
  '';

  meta = {
    description = "Surfshark VPN client";
    homepage = "https://surfshark.com";
    downloadPage = "https://surfshark.com/download/linux";
    mainProgram = "surfshark";
    license = lib.licenses.unfree;
    platforms = [ "x86_64-linux" ];
    sourceProvenance = with lib.sourceTypes; [ binaryNativeCode ];
    maintainers = with lib.maintainers; [ FazalAAli ];
  };
})
