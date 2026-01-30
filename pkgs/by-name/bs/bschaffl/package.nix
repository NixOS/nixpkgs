{
  lib,
  stdenv,
  fetchFromGitHub,
  pkg-config,
  cairo,
  libX11,
  lv2,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "bschaffl";
  version = "1.4.10";

  src = fetchFromGitHub {
    owner = "sjaehn";
    repo = "bschaffl";
    tag = finalAttrs.version;
    sha256 = "sha256-zfhPYH4eUNWHV27ZtX2IIvobyPdKs5yGr/ryJRQa6as=";
  };

  nativeBuildInputs = [ pkg-config ];
  buildInputs = [
    cairo
    libX11
    lv2
  ];

  installFlags = [ "PREFIX=$(out)" ];

  enableParallelBuilding = true;

  meta = {
    homepage = "https://github.com/sjaehn/BSchaffl";
    description = "Pattern-controlled MIDI amp & time stretch LV2 plugin";
    maintainers = [ lib.maintainers.magnetophon ];
    platforms = lib.platforms.linux;
    license = lib.licenses.gpl3;
  };
})
