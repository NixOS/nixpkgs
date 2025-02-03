{ stdenv
, lib
, fetchFromGitHub
, fetchurl
, fetchpatch
, meson
, ninja
, m4
, gperf
, getent
, acl
, audit
, dbus
, libcap
, libselinux
, pam
, gettext
, pkg-config
, udev
, eudev
, util-linux
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

stdenv.mkDerivation rec {
  pname = "elogind";
  version = "255.5";

  src = fetchFromGitHub {
    owner = "elogind";
    repo = pname;
    rev = "v${version}";
    hash = "sha256-4KZr/NiiGVwzdDROhiX3GEQTUyIGva6ezb+xC2U3bkg=";
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

    python3Packages.python
    python3Packages.jinja2
  ];

  buildInputs = [ acl audit dbus libcap libselinux pam util-linux ]
    ++ (if enableSystemd then [ udev ] else [ eudev ]);

  postPatch = ''
    substituteInPlace meson.build --replace-fail "install_emptydir(elogindstatedir)" ""
  '';

  patches = [
    (fetchurl {
      url = "https://github.com/chimera-linux/cports/raw/49d65fe38be815b9918a15ac2d2ff2b123fc559a/main/elogind/patches/strerror_r.patch";
      hash = "sha256-amqXP12mLtrkWuAURb3/aoQeeTSRYlYqL2q2zrKbhxk=";
    })
    (fetchurl {
      url = "https://github.com/chimera-linux/cports/raw/49d65fe38be815b9918a15ac2d2ff2b123fc559a/main/elogind/patches/strerror_r_1.patch";
      hash = "sha256-tVUlmPValUPApqRX+Cqkzn7bkIILYSuCouvgRsdl9XE=";
    })
    (fetchpatch {
      url = "https://github.com/chimera-linux/cports/raw/49d65fe38be815b9918a15ac2d2ff2b123fc559a/main/elogind/patches/xxx-musl-fixes.patch";
      includes = [
        "src/basic/cgroup-util.c"
        "src/basic/missing_prctl.h"
        "src/libelogind/sd-journal/journal-file.h"
      ];
      hash = "sha256-kY+B1t87E/TtWa83r0VoiojhRrrB667ZhUAHtHE7m28=";
    })
    (fetchurl {
      url = "https://github.com/chimera-linux/cports/raw/49d65fe38be815b9918a15ac2d2ff2b123fc559a/main/elogind/patches/gshadow.patch";
      hash = "sha256-YBy1OeWD1EluLTeUvqUvZKyrZyoUbGg1mxwqG5+VNO0=";
    })
    (fetchurl {
      name = "FTW.patch";
      url = "https://git.openembedded.org/openembedded-core/plain/meta/recipes-core/systemd/systemd/0005-add-missing-FTW_-macros-for-musl.patch?id=6bc5e3f3cd882c81c972dbd27aacc1ce00e5e59a";
      hash = "sha256-SGvP0GT43vfyHxrmvl4AbsWQz8CPmNGyH001s3lTxng=";
    })
    (fetchurl {
      name = "malloc_info.patch";
      url = "https://git.openembedded.org/openembedded-core/plain/meta/recipes-core/systemd/systemd/0016-pass-correct-parameters-to-getdents64.patch?id=6bc5e3f3cd882c81c972dbd27aacc1ce00e5e59a";
      hash = "sha256-8aOw+BTtl5Qta8aqLmliKSHEirTjp1xLM195EmBdEDI=";
    })
    (fetchpatch {
      name = "malloc_trim.patch";
      url = "https://git.openembedded.org/openembedded-core/plain/meta/recipes-core/systemd/systemd/0020-sd-event-Make-malloc_trim-conditional-on-glibc.patch?id=6bc5e3f3cd882c81c972dbd27aacc1ce00e5e59a";
      stripLen = 3;
      extraPrefix = [ "src/libelogind/" ];
      hash = "sha256-rtSnCEK+frhnlwl/UW3YHxB8MUCAq48jEzQRURpxdXk=";
    })
    (fetchurl {
      name = "malloc_info.patch";
      url = "https://git.openembedded.org/openembedded-core/plain/meta/recipes-core/systemd/systemd/0021-shared-Do-not-use-malloc_info-on-musl.patch?id=6bc5e3f3cd882c81c972dbd27aacc1ce00e5e59a";
      hash = "sha256-ZyOCmM5LcwJ7mHiZr0lQjV4G+XMxjhsUm7g7L3OzDDM=";
    })
    ./0001-Remove-outdated-musl-hack-in-rlimit_nofile_safe.patch
  ];

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
    (lib.mesonOption "dbuspolicydir" "${placeholder "out"}/share/dbus-1/system.d")
    (lib.mesonOption "dbussystemservicedir" "${placeholder "out"}/share/dbus-1/system-services")
    (lib.mesonOption "sysconfdir" "${placeholder "out"}/etc")
    (lib.mesonBool "utmp" (!stdenv.hostPlatform.isMusl))
    (lib.mesonEnable "xenctrl" false)
  ];

  meta = with lib; {
    homepage = "https://github.com/elogind/elogind";
    description = ''The systemd project's "logind", extracted to a standalone package'';
    platforms = platforms.linux; # probably more
    license = licenses.lgpl21Plus;
    maintainers = with maintainers; [ nh2 ];
  };
}
