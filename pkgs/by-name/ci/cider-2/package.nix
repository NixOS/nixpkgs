{
  lib,
  stdenv,
  fetchurl,
  dpkg,
  autoPatchelfHook,
  makeWrapper,

  # Required dependencies for autoPatchelfHook
  alsa-lib,
  gtk3,
  libgbm,
  nspr,
  nss,
}:
stdenv.mkDerivation rec {
  pname = "cider-2";
  version = "3.0.0";

  src = fetchurl {
    url = "https://repo.cider.sh/apt/pool/main/cider-v${version}-linux-x64.deb";
    hash = "sha256-XKyzt8QkPNQlgFxR12KA5t+PCJki7UuFpn4SGmoGkpg=";
  };

  nativeBuildInputs = [
    dpkg
    autoPatchelfHook
    makeWrapper
  ];

  buildInputs = [
    alsa-lib
    gtk3
    libgbm
    nspr
    nss
  ];

  unpackPhase = ''
    runHook preUnpack
    dpkg-deb --fsys-tarfile $src | tar --extract
    runHook postUnpack
  '';

  installPhase = ''
    runHook preInstall

    mkdir -p $out/{bin,share,lib}
    cp -r usr/share/* $out/share/
    cp -r usr/lib/* $out/lib/

    chmod +x $out/lib/cider/Cider

    runHook postInstall
  '';

  postFixup = ''
    makeWrapper $out/lib/cider/Cider $out/bin/${pname} \
      --add-flags "\$\{NIXOS_OZONE_WL:+\$\{WAYLAND_DISPLAY:+--ozone-platform-hint=auto --enable-features=WaylandWindowDecorations --enable-wayland-ime=true\}\}" \
      --add-flags "--no-sandbox --disable-gpu-sandbox"

    mv $out/share/applications/cider.desktop $out/share/applications/${pname}.desktop
    substituteInPlace $out/share/applications/${pname}.desktop \
      --replace-warn 'Exec=cider' 'Exec=${pname}' \
      --replace-warn 'Exec=/usr/lib/cider/Cider' 'Exec=${pname}'

    install -Dm444 $out/share/pixmaps/cider.png \
      $out/share/icons/hicolor/256x256/apps/cider.png
  '';

  meta = {
    description = "Powerful music player that allows you listen to your favorite tracks with style";
    homepage = "https://cider.sh";
    license = lib.licenses.unfree;
    mainProgram = "cider-2";
    maintainers = with lib.maintainers; [
      itsvic-dev
      l0r3v
    ];
    platforms = [ "x86_64-linux" ];
  };
}
