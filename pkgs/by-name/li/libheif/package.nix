{
  lib,
  stdenv,
  fetchFromGitHub,
  fetchpatch,
  cmake,
  pkg-config,
  dav1d,
  rav1e,
  libde265,
  x265,
  libpng,
  libjpeg,
  libaom,
  gdk-pixbuf,

  # for passthru.tests
  gimp,
  imagemagick,
  imlib2Full,
  imv,
  python3Packages,
  vips,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "libheif";
  version = "1.20.2";

  outputs = [
    "bin"
    "out"
    "dev"
    "man"
    "lib"
  ];

  src = fetchFromGitHub {
    owner = "strukturag";
    repo = "libheif";
    rev = "v${finalAttrs.version}";
    hash = "sha256-PVfdX3/Oe3DXpYU5WMnCSi2p9X4fPszq2X3uuyh8RVU=";
  };

  patches = [
    # CVE-2025-68431 (https://github.com/strukturag/libheif/security/advisories/GHSA-j87x-4gmq-cqfq)
    (fetchpatch {
      name = "001-fix-wrong-copy-width-in-overlay-images.patch";
      url = "https://github.com/strukturag/libheif/commit/b8c12a7b70f46c9516711a988483bed377b78d46.patch";
      hash = "sha256-PzGfcbdWAPdfExbSrPQwpk4v++TcNCXOhtwhgLGM13c=";
    })
  ];

  nativeBuildInputs = [
    pkg-config
    cmake
  ];

  buildInputs = [
    dav1d
    rav1e
    libde265
    x265
    libpng
    libjpeg
    libaom
    gdk-pixbuf
  ];

  # Fix installation path for gdk-pixbuf module
  PKG_CONFIG_GDK_PIXBUF_2_0_GDK_PIXBUF_MODULEDIR = "${placeholder "lib"}/${gdk-pixbuf.moduleDir}";

  postInstall = ''
    substituteInPlace $out/share/thumbnailers/heif.thumbnailer \
      --replace-fail "TryExec=heif-thumbnailer" "TryExec=$bin/bin/heif-thumbnailer" \
      --replace-fail "Exec=heif-thumbnailer" "Exec=$bin/bin/heif-thumbnailer"
  '';

  # Wrong include path in .cmake.  It's a bit difficult to patch because of special characters.
  postFixup = ''
    sed '/^  INTERFACE_INCLUDE_DIRECTORIES/s|"[^"]*/include"|"${placeholder "dev"}/include"|' \
      -i "$dev"/lib/cmake/libheif/libheif-config.cmake
  '';

  passthru.tests = {
    inherit
      gimp
      imagemagick
      imlib2Full
      imv
      vips
      ;
    inherit (python3Packages) pillow-heif;
  };

  meta = {
    homepage = "http://www.libheif.org/";
    description = "ISO/IEC 23008-12:2017 HEIF image file format decoder and encoder";
    license = lib.licenses.lgpl3Plus;
    platforms = lib.platforms.unix;
    knownVulnerabilities = [
      "(GHSA-jvmp-j3cw-84mh) - unbounded heap allocation in HEIF sequence parser (stsz fixed-size mode missing bound check)"
      "CVE-2026-49271 (GHSA-r7qj-cg5r-r6vf) - Wrapped icef compressed-unit range check causes out-of-bounds read in uncompressed HEIF decoder"
      "(GHSA-5hqq-636x-r3cr) - Out-of-bounds write in inline mask region API when source mask exceeds declared region"
      "CVE-2026-32738 (GHSA-7f2h-cmpf-v9ww) : Heap OOB Read / SEGV Crash via Zero samples_per_chunk in stsc"
      "CVE-2026-32739 (GHSA-j9g7-q9hv-gq8c) : Infinite Loop DoS in stts Sample Duration Lookup"
      "CVE-2026-32740 (GHSA-frfr-f3vg-2g6j) : Heap-Buffer-Overflow Write in Grid Tile Chroma Compositing"
      "CVE-2026-32741 (GHSA-j3w5-7whq-p37q) : heap buffer overflow in decode_mask_image()"
      "CVE-2026-32814 (GHSA-4m8r-34pg-rvwc) : Uninitialized Heap Memory Information Leak via Failed Grid Tiles"
      "CVE-2026-32882 (GHSA-hg7q-rjr2-8x46) : Heap Buffer OOB Read in overlay compositing due to wrong alpha stride"
      "CVE-2026-41069 (GHSA-p82x-fpmv-576r) : Out-of-bounds vector access leading to invalid dereference"
      "CVE-2026-41071 (GHSA-xj92-xjff-h8w3) : Heap buffer over-read in SampleAuxInfoReader via crafted HEIF sequence file with mismatched saiz sample count"
      "CVE-2026-47178 (GHSA-5x55-x5pf-9c6g) : Heap Out Of Bounds Write in unci subsystem"
      "CVE-2026-47247 (GHSA-2vh6-whr3-cmq3) : Heap Information Disclosure via Grid Image Gap + Uninitialized Pixel Plane Allocation"
      "CVE-2026-47251 (GHSA-p6q9-fhf2-vj9v) : Incomplete fix for CVE-2026-3949: integer overflow bypass in vvdec_push_data2"
      "CVE-2026-47254 (GHSA-wqjg-4x9g-6cvg) : Heap Buffer Overflow in Track::get_next_sample_raw_data() -- OOB Chunk Vector Access"
      "CVE-2026-47709 (GHSA-4h72-vqgp-9376) : NULL pointer dereference in heif_image_handle_get_image_tiling for malformed unci image missing ispe"
      "CVE-2026-47714 (GHSA-h4wm-6wwf-qvhx) : Integer overflow in inline mask size calculation causes undersized buffer allocation"
      "CVE-2026-48029 (GHSA-6x5f-qchq-cxqv) : heap OOB read in ImageItem_Grid::decode_grid_tile via irot-induced tile-coordinate underflow"
      "(GHSA-95jx-g5vf-cpp8) : Integer Overflow in SampleAuxInfoReader Offset Calculation"
      "(GHSA-p4r6-6972-g26m) : Incorrect byte-count initialization in BitstreamRange constructor allows container-boundary check bypass"
      "(GHSA-jh2w-m72q-q595) : Out-of-bounds read and assertion-based DoS in EXIF parsing (find_exif_tag / read32) with short EXIF TIFF payload"
      "(GHSA-9h96-c44j-jpq9) : Heap buffer overflow via uint32_t stride overflow in image plane allocation"
      "CVE-2025-68431 : heap buffer over-read in `HeifPixelImage::overlay()`"
    ];
    maintainers = with lib.maintainers; [ kuflierl ];
  };
})
