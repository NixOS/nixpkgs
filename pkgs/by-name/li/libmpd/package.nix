{
  lib,
  stdenv,
  fetchurl,
  pkg-config,
  doxygen,
  glib,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "libmpd";
  version = "11.8.17";
  outputs = [
    "out"
    "dev"
    "devdoc"
  ];

  src = fetchurl {
    url = "https://www.musicpd.org/download/libmpd/${finalAttrs.version}/libmpd-${finalAttrs.version}.tar.gz";
    hash = "sha256-/iAyaw0QZB9xxGc/rmN7+SIqluFxL3HxcPyi/DS/eoM=";
  };

  nativeBuildInputs = [
    pkg-config
    doxygen
  ];
  buildInputs = [
    glib
  ];

  postInstall = ''
    make doc
    mkdir -p $devdoc/share/devhelp/libmpd
    cp -r doc/html $devdoc/share/devhelp/libmpd/doxygen
  '';

  meta = with lib; {
    description = "Higher level access to MPD functions";
    homepage = "https://www.musicpd.org/download/libmpd/";
    changelog = "https://www.musicpd.org/download/libmpd/${finalAttrs.version}/README";
    license = licenses.gpl2Only;
    maintainers = with maintainers; [ doronbehar ];
    platforms = platforms.all;
    # Getting DARWIN_NULL related errors
    broken = stdenv.hostPlatform.isDarwin;
  };
})
