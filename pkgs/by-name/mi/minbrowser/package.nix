{
  lib,
  stdenv,
  fetchurl,

  dpkg,
  autoPatchelfHook,

  libxkbcommon,
  libxcb,
  xorg,
  alsa-lib,
  nss,
  at-spi2-core,
  mesa,
  cairo,
  pango,
  cups,
  gtk3,
  glib,

  nix-update-script,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "min";
  version = "1.34.1";

  src = fetchurl {
    url = "https://github.com/minbrowser/min/releases/download/v${finalAttrs.version}/min-${finalAttrs.version}-amd64.deb";
    hash = "sha256-gpkjGYuHwBY3IwK5bXhzIPPosSTZ67hclmGLT4PTsG4=";
  };

  nativeBuildInputs = [
    dpkg
    autoPatchelfHook
  ];

  buildInputs = [
    libxkbcommon # libxkbcommon.so
    libxcb # libxcb.so
    at-spi2-core # libatspi.so
    mesa # libdbm.so libexpat.so
    cairo # libcairo.so
    cups # libcups.so
    gtk3 # libgtk-3.so
    pango # libpango-1.0.so
    (with xorg; [
      libX11 # libX11.so
      libXcomposite # libXcomposite.so
      libXdamage # libXdamage.so
      libXext # libXext.so
      libXfixes # libXfixes.so
      libXrandr # libXrandr.so
    ])
    nss # libnss3.so
    alsa-lib # libasound.so
    glib # libglib-2.0.so libgobject-2.0.so libgio.so
    stdenv.cc.cc.lib # libgcc_s.so
  ];

  unpackPhase = "
    dpkg-deb -x $src $out
    mv $out/usr/share $out
    mkdir -p $out/bin
    ln -s $out/opt/Min/min $out/bin/min
  ";

  passthru.updateScript = nix-update-script { };

  meta = {
    description = "Fast, minimal browser that protects your privacy";
    homepage = "https://github.com/minbrowser/min";
    changelog = "https://github.com/minbrowser/min/releases/tag/v${finalAttrs.version}";
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [ kashw2 ];
  };
})
