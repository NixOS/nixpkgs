{
  stdenv,
  lib,
  fetchgit,
  pkg-config,
  meson,
  ninja,
  systemd,
  liburing,
  zstd,
}:
stdenv.mkDerivation (finalAttrs: {
  pname = "plocate";
  version = "1.1.25";

  src = fetchgit {
    url = "https://git.sesse.net/plocate";
    rev = finalAttrs.version;
    sha256 = "sha256-EXlmisJObF3WVDI1KxlFeFDmaUqwsHWZSwUAXH1CITs=";
  };

  postPatch = ''
    sed -i meson.build \
      -e '/mkdir\.sh/d'
  '';

  nativeBuildInputs = [
    meson
    ninja
    pkg-config
  ];

  buildInputs = [
    systemd
    liburing
    zstd
  ];

  mesonFlags = [
    "-Dsystemunitdir=${placeholder "out"}/etc/systemd/system"
    "-Dsharedstatedir=/var/cache"
    "-Ddbpath=locatedb"
  ];

  meta = {
    description = "Much faster locate";
    homepage = "https://plocate.sesse.net/";
    license = lib.licenses.gpl2Plus;
    maintainers = with lib.maintainers; [
      peterhoeg
      SuperSandro2000
    ];
    platforms = lib.platforms.linux;
  };
})
