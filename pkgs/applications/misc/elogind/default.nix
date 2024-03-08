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
, pkg-config
, udev
, eudev
, libxslt
, python3
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

stdenv.mkDerivation rec {
  pname = "elogind";
  version = "246.10";

  src = fetchFromGitHub {
    owner = "elogind";
    repo = pname;
    rev = "v${version}";
    sha256 = "sha256-+Nv6FL9Yjmfxs24+2mUTP//wbjzGUq4ftgJLfuEqBJg=";
  };

  nativeBuildInputs = [
    meson
    ninja
    m4
    pkg-config
    gperf
    getent
    libcap
    gettext
    libxslt.bin # xsltproc
    docbook5 docbook_xsl docbook_xsl_ns docbook_xml_dtd_42 docbook_xml_dtd_45 # needed for docbook without Internet
    (python3.withPackages (p: with p; [ lxml ]))  # fixes: man/meson.build:111:0: ERROR: Could not execute command "/build/source/tools/xml_helper.py".
  ];

  buildInputs =
    if enableSystemd then [ udev ] else [ eudev ];

  # Inspired by the systemd `preConfigure`.
  # Conceptually we should patch all files required during the build, but not scripts
  # supposed to run at run-time of the software (important for cross-compilation).
  # This package seems to have mostly scripts that run at build time.
  preConfigure = ''
    for dir in tools src/test; do
      patchShebangs $dir
    done

    patchShebangs src/basic/generate-*.{sh,py}
  '';

  mesonFlags = [
    "-Drootprefix=${placeholder "out"}"
    "-Dsysconfdir=${placeholder "out"}/etc"
  ];

  meta = with lib; {
    homepage = "https://github.com/elogind/elogind";
    description = ''The systemd project's "logind", extracted to a standalone package'';
    platforms = platforms.linux; # probably more
    license = licenses.lgpl21Plus;
    maintainers = with maintainers; [ nh2 ];
  };
}
