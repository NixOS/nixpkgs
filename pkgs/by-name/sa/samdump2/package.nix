{
  lib,
  stdenv,
  fetchurl,
  fetchpatch,
  openssl,
  pkg-config,
  which,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "samdump2";
  version = "3.0.0";

  src = fetchurl {
    url = "mirror://sourceforge/project/ophcrack/samdump2/${finalAttrs.version}/samdump2-${finalAttrs.version}.tar.bz2";
    hash = "sha256-YCZZrzDFZXUPoBZQ4KIj0mNVtd+Y8vvDDjpsWT7U5SY=";
  };

  nativeBuildInputs = [
    pkg-config
    which
  ];
  buildInputs = [
    openssl
  ];

  patches = [
    (fetchpatch {
      # fixes a FTBFS linker bug
      url = "https://salsa.debian.org/pkg-security-team/samdump2/-/raw/b4c9f14f5a1925106e7c62c9967d430c1104df0c/debian/patches/10_ftbfs_link.patch";
      hash = "sha256-TGzxi44dDAispG+rK/kYYMzKjt10p+ZyfVDWKG+Gw/s=";
    })
    (fetchpatch {
      # the makefile overrides flags so you can't set them via d/rules or the environment
      url = "https://salsa.debian.org/pkg-security-team/samdump2/-/raw/b4c9f14f5a1925106e7c62c9967d430c1104df0c/debian/patches/20_compiler_flags.patch";
      hash = "sha256-VdDiNAQhlauAB4Ws/pvWMJY2rMKr3qhyVGX2GoxaagI=";
    })
    (fetchpatch {
      # the makefile has a infos dep, but no target
      url = "https://salsa.debian.org/pkg-security-team/samdump2/-/raw/b4c9f14f5a1925106e7c62c9967d430c1104df0c/debian/patches/30_install_infos.patch";
      hash = "sha256-Y7kdU+ywUYFm2VySGFa0QE1OvzoTa0eFSWp0VFmY5iM=";
    })
    (fetchpatch {
      # change the formatting in the manpage to make it more readable
      url = "https://salsa.debian.org/pkg-security-team/samdump2/-/raw/b4c9f14f5a1925106e7c62c9967d430c1104df0c/debian/patches/40_manpage_formatting.patch";
      hash = "sha256-L4BjtiGk91nTKZdr0SXbaxkD2mzmkU3UJlc4TZfXS4Y=";
    })
    (fetchpatch {
      # fix a FTBFS with OpenSSL 1.1.0. (Closes: #828537)
      url = "https://salsa.debian.org/pkg-security-team/samdump2/-/raw/b4c9f14f5a1925106e7c62c9967d430c1104df0c/debian/patches/50_openssl.patch";
      hash = "sha256-pdLOSt7kX9uPg4wDVstxh3NC/DboQCP+5/wCjuJmruY=";
    })
  ];

  postPatch = ''
    substituteInPlace Makefile \
      --replace " -o root -g root" ""
  '';

  makeFlags = [
    "PREFIX=$(out)"
    "CC=cc"
  ];

  meta = with lib; {
    description = "Dump password hashes from a Windows NT/2k/XP installation";
    mainProgram = "samdump2";
    homepage = "https://sourceforge.net/projects/ophcrack/files/samdump2";
    license = licenses.gpl2Plus;
    maintainers = with maintainers; [ d3vil0p3r ];
    platforms = platforms.unix;
  };
})
