{
  stdenvNoCC,
  pkg-config,
  pkg-config-unwrapped,
  makeWrapper,
  gtk3,
  libx11,
  libxi,
}:

stdenvNoCC.mkDerivation {
  name = "wrap-pkg-config";
  dontUnpack = true;

  nativeBuildInputs = [
    pkg-config
    makeWrapper
  ];

  buildInputs = [
    gtk3
    libx11
    libxi
  ];

  installPhase = ''
    makeWrapper ${pkg-config-unwrapped}/bin/pkg-config $out/bin/pkg-config \
      --prefix PKG_CONFIG_PATH : "$PKG_CONFIG_PATH"
  '';
}
