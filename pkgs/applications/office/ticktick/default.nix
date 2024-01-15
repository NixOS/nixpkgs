{ lib
, fetchurl
, stdenv
, wrapGAppsHook
, dpkg
, autoPatchelfHook
, glibc
, gcc-unwrapped
, nss
, libdrm
, mesa
, alsa-lib
, xdg-utils
, systemd
}:
stdenv.mkDerivation (finalAttrs: {
  pname = "ticktick";
  version = "2.0.0";

  src = fetchurl {
    url = "https://d2atcrkye2ik4e.cloudfront.net/download/linux/linux_deb_x64/${finalAttrs.pname}-${finalAttrs.version}-amd64.deb";
    hash = "sha256-LOllYdte+Y+pbjXI2zOQrwptmUo4Ck6OyYoEX6suY08=";
  };

  nativeBuildInputs = [
    wrapGAppsHook
    autoPatchelfHook
    dpkg
  ];

  buildInputs = [
    nss
    glibc
    libdrm
    gcc-unwrapped
    mesa
    alsa-lib
    xdg-utils
  ];

  # Needed to make the process get past zygote_linux fork()'ing
  runtimeDependencies = [
    systemd
  ];

  unpackPhase = ''
    runHook preUnpack

    mkdir -p "$out/share" "$out/opt/${finalAttrs.pname}" "$out/bin"
    dpkg-deb --fsys-tarfile "$src" | tar --extract --directory="$out"

    runHook postUnpack
  '';

  installPhase = ''
    runHook preInstall

    cp -av $out/opt/TickTick/* $out/opt/${finalAttrs.pname}
    cp -av $out/usr/share/* $out/share
    rm -rf $out/usr $out/opt/TickTick
    ln -sf "$out/opt/${finalAttrs.pname}/${finalAttrs.pname}" "$out/bin/${finalAttrs.pname}"

    substituteInPlace "$out/share/applications/${finalAttrs.pname}.desktop" \
      --replace "Exec=/opt/TickTick/ticktick" "Exec=$out/bin/${finalAttrs.pname}"

    runHook postInstall
  '';

  meta = with lib; {
    description = "A powerful to-do & task management app with seamless cloud synchronization across all your devices";
    homepage = "https://ticktick.com/home/";
    license = licenses.unfree;
    maintainers = with maintainers; [ hbjydev ];
    platforms = [ "x86_64-linux" ];
    sourceProvenance = with sourceTypes; [ binaryNativeCode ];
  };
})
