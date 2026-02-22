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
  version = "1.1.24";

  src = fetchgit {
    url = "https://git.sesse.net/plocate";
    rev = finalAttrs.version;
    sha256 = "sha256-VvHptw/PG2uWflTmGNCj1PXIguXv9Bikz8qj2hRMnaQ=";
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
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [
      peterhoeg
      SuperSandro2000
    ];
    platforms = lib.platforms.linux;
  };
})
