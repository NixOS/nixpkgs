{
  lib,
  stdenv,
  fetchurl,
  dpkg,
  autoPatchelfHook,
  webkitgtk_4_1,
  libsoup_3,
  glib,
  gtk3,
  cairo,
  dbus,
  gdk-pixbuf,
  nix-update-script,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "museeks";
  version = "0.23.0";

  src = fetchurl {
    url = "https://github.com/martpie/museeks/releases/download/${finalAttrs.version}/Museeks_${finalAttrs.version}_amd64.deb";
    hash = "sha256-CT/P6tVgS7KD401ZktJBz1rk9CAz6gCm5zefud+prqQ=";
  };

  nativeBuildInputs = [
    dpkg
    autoPatchelfHook
  ];

  buildInputs = [
    dbus
    webkitgtk_4_1
    libsoup_3
    gtk3
    cairo
    gdk-pixbuf
    glib
    (lib.getLib stdenv.cc.cc)
  ];

  installPhase = ''
    runHook preInstall

    cp -r usr $out

    runHook postInstall
  '';

  passthru.updateScript = nix-update-script { };

  meta = {
    description = "Simple, clean and cross-platform music player";
    homepage = "https://github.com/martpie/museeks";
    license = lib.licenses.mit;
    platforms = [ "x86_64-linux" ];
    maintainers = with lib.maintainers; [ zendo ];
    mainProgram = "museeks";
  };
})
