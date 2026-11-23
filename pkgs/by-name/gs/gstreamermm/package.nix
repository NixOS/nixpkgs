{
  lib,
  stdenv,
  fetchurl,
  fetchpatch,
  pkg-config,
  file,
  glibmm_2_4,
  gst-plugins-base,
  gnome,
  apple-sdk,
  testers,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "gstreamermm";
  version = "1.10.0";

  src = fetchurl {
    url = "mirror://gnome/sources/gstreamermm/${lib.versions.majorMinor finalAttrs.version}/gstreamermm-${finalAttrs.version}.tar.xz";
    hash = "sha256-vlj+nvfX45JWjshegKhPRzCtv5H7A1X/fXxhZnXqjWA=";
  };

  patches = [
    (fetchpatch {
      name = "gstreamermm-${finalAttrs.version}.fix-build-against-glib-2.68.patch";
      url = "https://gitlab.gnome.org/GNOME/gstreamermm/-/commit/37116547fb5f9066978e39b4cf9f79f2154ad425.patch";
      hash = "sha256-YHtmOiOl4POwas3eWHsew3IyGK7Aq22MweBm3JPwyBM=";
    })
  ];

  outputs = [
    "out"
    "dev"
  ];

  strictDeps = true;
  __structuredAttrs = true;

  buildInputs = lib.optionals stdenv.hostPlatform.isDarwin [
    apple-sdk
  ];

  nativeBuildInputs = [
    pkg-config
    file
  ];

  propagatedBuildInputs = [
    glibmm_2_4
    gst-plugins-base
  ];

  enableParallelBuilding = true;

  passthru = {
    updateScript = gnome.updateScript {
      attrPath = "gstreamermm";
      packageName = "gstreamermm";
      versionPolicy = "odd-unstable";
    };
    tests.pkg-config = testers.testMetaPkgConfig finalAttrs.finalPackage;
  };

  meta = {
    description = "C++ interface for GStreamer";
    homepage = "https://gstreamer.freedesktop.org/bindings/cplusplus.html";
    license = lib.licenses.lgpl21Plus;
    pkgConfigModules = [ "gstreamermm-1.0" ];
    platforms = lib.platforms.linux;
    maintainers = with lib.maintainers; [ romildo ];
  };

})
