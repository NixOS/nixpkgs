{
  lib,
  stdenv,
  fetchurl,
  meson,
  ninja,
  file,
  docbook-xsl-nons,
  gtk-doc ? null,
  buildDevDoc ? gtk-doc != null,

  # for passthru.tests
  gnuradio,
  gst_all_1,
  qt6,
  vips,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "orc";
  version = "0.4.41";

  outputs = [
    "out"
    "dev"
  ]
  ++ lib.optional buildDevDoc "devdoc";
  outputBin = "dev"; # compilation tools

  src = fetchurl {
    url = "https://gstreamer.freedesktop.org/src/orc/orc-${finalAttrs.version}.tar.xz";
    hash = "sha256-yxv9T2VSic05vARkLVl76d5UJ2I/CGHB/BnAjZhGf6I=";
  };

  postPatch = lib.optionalString (stdenv.hostPlatform.isDarwin && stdenv.hostPlatform.isx86_64) ''
    # This benchmark times out on Hydra.nixos.org
    sed -i '/memcpy_speed/d' testsuite/meson.build
  '';

  mesonFlags = [
    (lib.mesonEnable "gtk_doc" buildDevDoc)
  ];

  nativeBuildInputs = [
    meson
    ninja
  ]
  ++ lib.optionals buildDevDoc [
    gtk-doc
    file
    docbook-xsl-nons
  ];

  # https://gitlab.freedesktop.org/gstreamer/orc/-/issues/41
  doCheck =
    !(
      stdenv.hostPlatform.isLinux
      && stdenv.hostPlatform.isAarch64
      && stdenv.cc.isGNU
      && lib.versionAtLeast stdenv.cc.version "12"
    );

  passthru.tests = {
    inherit (gst_all_1) gst-plugins-good gst-plugins-bad gst-plugins-ugly;
    inherit gnuradio vips;
    qt6-qtmultimedia = qt6.qtmultimedia;
  };

  meta = with lib; {
    description = "Oil Runtime Compiler";
    homepage = "https://gstreamer.freedesktop.org/projects/orc.html";
    changelog = "https://gitlab.freedesktop.org/gstreamer/orc/-/blob/${finalAttrs.version}/RELEASE";
    # The source code implementing the Marsenne Twister algorithm is licensed
    # under the 3-clause BSD license. The rest is 2-clause BSD license.
    license = with licenses; [
      bsd3
      bsd2
    ];
    platforms = platforms.unix;
    maintainers = [ ];
  };
})
