{
  lib,
  stdenv,
  fetchurl,
  meson,
  ninja,
  file,
  docbook_xsl,
  gtk-doc ? null,
  buildDevDoc ? gtk-doc != null,

  # for passthru.tests
  gnuradio,
  gst_all_1,
  qt6,
  vips,

}:
let
  inherit (lib) optional optionals;
in
stdenv.mkDerivation rec {
  pname = "orc";
  version = "0.4.40";

  src = fetchurl {
    url = "https://gstreamer.freedesktop.org/src/orc/${pname}-${version}.tar.xz";
    hash = "sha256-P8K+5437fEH9lgUGH8aRONt98Afq4vZpofVui6zvdKs=";
  };

  postPatch = lib.optionalString (stdenv.hostPlatform.isDarwin && stdenv.hostPlatform.isx86_64) ''
    # This benchmark times out on Hydra.nixos.org
    sed -i '/memcpy_speed/d' testsuite/meson.build
  '';

  outputs = [
    "out"
    "dev"
  ] ++ optional buildDevDoc "devdoc";
  outputBin = "dev"; # compilation tools

  mesonFlags = optionals (!buildDevDoc) [ "-Dgtk_doc=disabled" ];

  nativeBuildInputs =
    [
      meson
      ninja
    ]
    ++ optionals buildDevDoc [
      gtk-doc
      file
      docbook_xsl
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
    changelog = "https://cgit.freedesktop.org/gstreamer/orc/plain/RELEASE?h=${version}";
    # The source code implementing the Marsenne Twister algorithm is licensed
    # under the 3-clause BSD license. The rest is 2-clause BSD license.
    license = with licenses; [
      bsd3
      bsd2
    ];
    platforms = platforms.unix;
    maintainers = [ ];
  };
}
