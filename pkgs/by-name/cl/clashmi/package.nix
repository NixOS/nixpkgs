{
  lib,
  stdenv,
  fetchurl,
  autoPatchelfHook,
  dpkg,
  atk,
  cairo,
  curlMinimal,
  fontconfig,
  gdk-pixbuf,
  glib,
  gobject-introspection,
  gtk3,
  harfbuzz,
  keybinder3,
  libayatana-appindicator,
  libepoxy,
  libsecret,
  pango,
  zlib,
  nix-update-script,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "clashmi";
  version = "1.0.12.162";

  src = fetchurl {
    url = "https://github.com/KaringX/clashmi/releases/download/v${finalAttrs.version}/clashmi_${finalAttrs.version}_linux_amd64.deb";
    hash = "sha256-Nb37SAeOLGCixiXOqsVBzlRcQAM5U90RYLthBZlMb9c=";
  };

  nativeBuildInputs = [
    autoPatchelfHook
    dpkg
  ];

  buildInputs = [
    atk
    cairo
    curlMinimal
    fontconfig
    gdk-pixbuf
    glib
    gobject-introspection
    gtk3
    harfbuzz
    keybinder3
    (lib.getLib stdenv.cc.cc)
    libayatana-appindicator
    libepoxy
    libsecret
    pango
    zlib
  ];

  installPhase = ''
    runHook preInstall

    cp --recursive usr $out
    mkdir $out/bin
    ln --symbolic $out/share/clashmi/clashmi $out/bin/clashmi
    ln --symbolic $out/share/clashmi/clashmiService $out/bin/clashmiService

    runHook postInstall
  '';

  passthru.updateScript = nix-update-script { };

  meta = {
    changelog = "https://github.com/KaringX/clashmi/releases/tag/v${finalAttrs.version}";
    description = "mihomo (clash.meta) graphical user interface based on Flutter";
    homepage = "https://github.com/KaringX/clashmi";
    license = with lib.licenses; [
      gpl3Plus
      unfree
    ];
    mainProgram = "clashmi";
    maintainers = with lib.maintainers; [ qzylinra ];
    platforms = [ "x86_64-linux" ];
  };
})
