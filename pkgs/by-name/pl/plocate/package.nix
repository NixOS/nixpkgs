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
stdenv.mkDerivation rec {
  pname = "plocate";
  version = "1.1.23";

  src = fetchgit {
    url = "https://git.sesse.net/plocate";
    rev = version;
    sha256 = "sha256-TWQ2mVzosB6sGNUXI2D9GGqgaRZcmiL9GSGrrusck5Q=";
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

  meta = with lib; {
    description = "Much faster locate";
    homepage = "https://plocate.sesse.net/";
    license = licenses.mit;
    maintainers = with maintainers; [
      peterhoeg
      SuperSandro2000
    ];
    platforms = platforms.linux;
  };
}
