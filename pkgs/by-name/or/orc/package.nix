{
  lib,
  stdenv,
  testers,
  nix-update-script,
  fetchFromGitLab,
  meson,
  ninja,
  hotdoc,
  buildDevDoc ? true,

  # for passthru.tests
  gnuradio,
  gst_all_1,
  qt6,
  vips,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "orc";
  version = "0.4.43";

  outputs = [
    "out"
    "dev"
  ]
  ++ lib.optional buildDevDoc "devdoc";
  outputBin = "dev"; # compilation tools
  outputDoc = lib.optionalString buildDevDoc "devdoc";

  src = fetchFromGitLab {
    domain = "gitlab.freedesktop.org";
    owner = "gstreamer";
    repo = "orc";
    tag = finalAttrs.version;
    hash = "sha256-Ec6TmkazDSvZLYBIZm9tXvD9Z9FWvvJqrIdYb4zfFjM=";
  };

  postPatch = lib.optionalString (stdenv.hostPlatform.isDarwin && stdenv.hostPlatform.isx86_64) ''
    # This benchmark times out on Hydra.nixos.org
    sed -i '/memcpy_speed/d' testsuite/meson.build
  '';

  mesonFlags = lib.mapAttrsToList lib.mesonEnable {
    examples = false;
    benchmarks = false;
    tests = finalAttrs.finalPackage.doCheck;
    hotdoc = buildDevDoc;
    tools = true;
  };

  nativeBuildInputs = [
    meson
    ninja
  ]
  ++ lib.optionals buildDevDoc [
    hotdoc
  ];

  # https://gitlab.freedesktop.org/gstreamer/orc/-/issues/41
  doCheck =
    !(
      stdenv.hostPlatform.isLinux
      && stdenv.hostPlatform.isAarch64
      && stdenv.cc.isGNU
      && lib.versionAtLeast stdenv.cc.version "12"
    );

  passthru = {
    tests = {
      inherit (gst_all_1) gst-plugins-good gst-plugins-bad gst-plugins-ugly;
      inherit gnuradio vips;
      qt6-qtmultimedia = qt6.qtmultimedia;
      pkg-config = testers.testMetaPkgConfig finalAttrs.finalPackage;
    };

    updateScript = nix-update-script { };
  };

  meta = {
    description = "Oil Runtime Compiler";
    homepage = "https://gstreamer.freedesktop.org/projects/orc.html";
    changelog = "https://gitlab.freedesktop.org/gstreamer/orc/-/blob/${finalAttrs.version}/RELEASE";
    pkgConfigModules = map (name: "${name}-${lib.versions.majorMinor finalAttrs.version}") [
      "orc"
      "orc-test"
    ];
    # The source code implementing the Marsenne Twister algorithm is licensed
    # under the 3-clause BSD license. The rest is 2-clause BSD license.
    license = with lib.licenses; [
      bsd3
      bsd2
    ];
    platforms = lib.platforms.unix;
    maintainers = with lib.maintainers; [ tmarkus ];
  };
})
