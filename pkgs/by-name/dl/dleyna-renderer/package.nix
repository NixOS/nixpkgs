{ stdenv
, lib
, fetchFromGitHub
, fetchpatch
, meson
, ninja
, pkg-config
, dleyna-connector-dbus
, dleyna-core
, gssdp
, gupnp
, gupnp-av
, gupnp-dlna
, libsoup_2_4
, makeWrapper
, docbook-xsl-nons
, libxslt
}:

stdenv.mkDerivation rec {
  pname = "dleyna-renderer";
  version = "0.7.2";

  src = fetchFromGitHub {
    owner = "phako";
    repo = pname;
    rev = "v${version}";
    sha256 = "sha256-bGasT3XCa7QHV3D7z59TSHoqWksNSIgaO0z9zYfHHuw=";
  };

  patches = [
    # Fix build with meson 1.2. We use the gentoo patch intead of the
    # usptream one because the latter only applies on the libsoup_3 based
    # merged dLeyna project.
    # https://gitlab.gnome.org/World/dLeyna/-/merge_requests/6
    (fetchpatch {
      url = "https://github.com/gentoo/gentoo/raw/2ebe20ff4cda180cc248d31a021107d08ecf39d9/net-libs/dleyna-renderer/files/meson-1.2.0.patch";
      sha256 = "sha256-/p2OaPO5ghWtPotwIir2TtcFF5IDFN9FFuyqPHevuFI=";
    })
  ];

  nativeBuildInputs = [
    meson
    ninja
    pkg-config
    makeWrapper

    # manpage
    docbook-xsl-nons
    libxslt # for xsltproc
  ];

  buildInputs = [
    dleyna-core
    dleyna-connector-dbus # runtime dependency to be picked up to DLEYNA_CONNECTOR_PATH
    gssdp
    gupnp
    gupnp-av
    gupnp-dlna
    libsoup_2_4
  ];

  preFixup = ''
    wrapProgram "$out/libexec/dleyna-renderer-service" \
      --set DLEYNA_CONNECTOR_PATH "$DLEYNA_CONNECTOR_PATH"
  '';

  meta = with lib; {
    description = "Library to discover and manipulate Digital Media Renderers";
    homepage = "https://github.com/phako/dleyna-renderer";
    maintainers = with maintainers; [ jtojnar ];
    platforms = platforms.unix;
    license = licenses.lgpl21Only;
  };
}
