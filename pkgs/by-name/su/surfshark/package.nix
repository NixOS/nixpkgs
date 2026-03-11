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
  xorg,
}:
let
  xorgDeps = with xorg; [
    libX11
    libXcomposite
    libXdamage
    libXext
    libXfixes
    libXrandr
    libxcb
    libXtst
  ];

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
  ] ++ xorgDeps;

  libPath = lib.makeLibraryPath (deps ++ [ (lib.getLib systemd) ]);
  binPath = lib.makeBinPath [
    coreutils
    procps
    which
    iputils
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
    makeBinaryWrapper
  ];

  buildInputs = deps;

  runtimeDependencies = [ (lib.getLib systemd) ];

  dontConfigure = true;
  dontBuild = true;
  dontStrip = true;

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

    # Patch GJS shebang and make daemon scripts executable
    for js in surfsharkd.js surfsharkd2.js; do
      daemon="$out/share/surfshark/resources/dist/resources/$js"
      substituteInPlace "$daemon" \
        --replace-fail "#!/usr/bin/gjs" "#!${gjs}/bin/gjs"
      chmod +x "$daemon"
    done

    # Fix .desktop Exec path
    sed -i "s|Exec=/opt/Surfshark/surfshark|Exec=$out/bin/surfshark|" \
      $out/share/applications/surfshark.desktop

    # Vulkan loader symlink (so bundled ANGLE finds libvulkan)
    ln -sf ${lib.getLib vulkan-loader}/lib/libvulkan.so.1 \
      $out/share/surfshark/libvulkan.so.1

    # Patch bundled GL libs rpath
    patchelf $out/share/surfshark/lib*GL* --set-rpath ${libPath} || true

    makeBinaryWrapper $out/share/surfshark/surfshark $out/bin/surfshark \
      --add-flags "--no-sandbox" \
      --prefix PATH : ${binPath} \
      --prefix LD_LIBRARY_PATH : ${libPath}

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
