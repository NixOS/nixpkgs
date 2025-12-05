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
  pname = "karing";
  version = "1.2.5.881";

  src = fetchurl {
    url = "https://github.com/KaringX/karing/releases/download/v${finalAttrs.version}/karing_${finalAttrs.version}_linux_amd64.deb";
    hash = "sha256-gkuKdOq07C7xd8xNoXWlcqaZ7xe9VmjU8e43Hg1yN7w=";
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
    ln --symbolic $out/share/karing/karing $out/bin/karing
    ln --symbolic $out/share/karing/karingService $out/bin/karingService

    runHook postInstall
  '';

  passthru.updateScript = nix-update-script { };

  meta = {
    changelog = "https://github.com/KaringX/karing/releases/tag/v${finalAttrs.version}";
    description = "Simple & Powerful proxy utility, Support routing rules for clash/sing-box";
    homepage = "https://github.com/KaringX/karing";
    license = with lib.licenses; [
      gpl3Plus
      unfree
    ];
    mainProgram = "karing";
    maintainers = with lib.maintainers; [ qzylinra ];
    platforms = [ "x86_64-linux" ];
  };
})
