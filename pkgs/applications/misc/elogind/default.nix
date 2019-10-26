{ stdenv
, lib
, fetchFromGitHub
, meson
, ninja
, m4
, gperf
, getent
, libcap
, gettext
, pkgconfig
, udev
, eudev
, libxslt
, python3Packages
, docbook5
, docbook_xsl
, docbook_xsl_ns
, docbook_xml_dtd_42
, docbook_xml_dtd_45

# Defaulting to false because usually the rationale for using elogind is to
# use it in situation where a systemd dependency does not work (especially
# when building with musl, which elogind explicitly supports).
, enableSystemd ? false
}:

with stdenv.lib;

stdenv.mkDerivation rec {
  pname = "elogind";
  version = "239.5";

  src = fetchFromGitHub {
    owner = "elogind";
    repo = pname;
    rev = "v${version}";
    sha256 = "1gdiy4vbx4gs2hnb79x14zi530mlq26glxpzp3c95w8l058wj4ba";
  };

  nativeBuildInputs = [
    meson
    ninja
    m4
    pkgconfig
    gperf
    getent
    libcap
    gettext
    libxslt.bin # xsltproc
    docbook5 docbook_xsl docbook_xsl_ns docbook_xml_dtd_42 docbook_xml_dtd_45 # needed for docbook without Internet
    python3Packages.lxml # fixes: man/meson.build:111:0: ERROR: Could not execute command "/build/source/tools/xml_helper.py".
  ];

  buildInputs =
    if enableSystemd then [udev] else [eudev];

  preConfigure = ''
    patchShebangs .
  '';

  mesonFlags = [
    "-Drootprefix=${placeholder "out"}"
    "-Dsysconfdir=${placeholder "out"}/etc"
  ];

  meta = {
    homepage = https://github.com/elogind/elogind/releases;
    description = ''The systemd project's "logind", extracted to a standalone package'';
    platforms = platforms.linux; # probably more
    license = licenses.gpl2;
    maintainers = with maintainers; [ nh2 ];
  };
}
