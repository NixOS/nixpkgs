{
  buildNpmPackage,
  fetchFromGitHub,
  lib,
  nix-update-script,
  stdenv,

  # nativeBuildInputs
  cmake,
  pkg-config,
  python3,
  wrapGAppsHook3,

  # buildInputs
  gtk3,
  libx11,
  webkitgtk_4_1,
  # buildInputs (gtk4Support)
  gtk4,
  webkitgtk_6_0,

  # Build the floating GTK4 editor; select it at runtime by launching the DAW
  # with CALFNXT_WEB_HOST=gtk4 or CALFNXT_WEB_FLOATING=1
  gtk4Support ? true,
}:
stdenv.mkDerivation (finalAttrs: {
  pname = "calfnxt";
  version = "2.13.1";
  __structuredAttrs = true;
  strictDeps = true;

  src = fetchFromGitHub {
    owner = "boomshop";
    repo = "calfnxt";
    tag = "v${finalAttrs.version}";
    hash = "sha256-4c63VZaT7PGWIinM+IxzKmSJO0GtuYNSDwmXgKMQO3o=";
  };

  postPatch = ''
    mkdir -p external
    ln -s ${finalAttrs.passthru.vst3sdk} external/vst3sdk
  '';

  nativeBuildInputs = [
    cmake
    pkg-config
    python3
    wrapGAppsHook3
  ];

  buildInputs = [
    gtk3
    libx11
    webkitgtk_4_1
  ]
  ++ lib.optionals gtk4Support [
    gtk4
    webkitgtk_6_0
  ];

  cmakeFlags = [
    (lib.cmakeBool "CALFNXT_WEB_HOST_GTK4" gtk4Support)
    (lib.cmakeBool "CALFNXT_USE_PREBUILT_UI" true)
    (lib.cmakeFeature "CALFNXT_UI_DIST" "${finalAttrs.passthru.ui}")
    (lib.cmakeFeature "CALFNXT_VST3_INSTALL_DIR" "lib/vst3")
  ];

  buildFlags = [ "calfnxt-plugins" ];

  # The helpers live inside VST3 bundles, outside the hook's usual search paths.
  dontWrapGApps = true;

  postFixup = ''
    for helper in "$out"/lib/vst3/*.vst3/Contents/*/calfnxt-web-host{,-gtk4}; do
      if [ -f "$helper" ]; then
        wrapGApp "$helper"
      fi
    done
  '';

  passthru = {
    updateScript = nix-update-script {
      extraArgs = [ "--subpackage=ui" ];
    };

    ui = buildNpmPackage {
      pname = "calfnxt-ui";
      inherit (finalAttrs) version src;
      sourceRoot = "${finalAttrs.src.name}/ui";
      __structuredAttrs = true;
      strictDeps = true;

      npmDepsHash = "sha256-fedyK8AIywOI1HCXv2RK6/MRrQRPJJCU1OghxE63qYA=";

      nativeBuildInputs = [ python3 ];

      # The UI imports models generated from the DSP plugin descriptors.
      preBuild = ''
        for descriptor in ../dsp/*/*.plugin.json; do
          plugin=$(basename "$descriptor" .plugin.json)
          python3 ../tools/codegen/generate_plugin.py \
            --descriptor "$descriptor" \
            --cpp-out "$TMPDIR/''${plugin}_params.h" \
            --ts-out "src/generated/''${plugin}Model.ts"
        done
      '';

      # CMake only checks that this file exists; omit the build timestamp.
      postBuild = ''
        : > dist/.stamp
      '';

      installPhase = ''
        runHook preInstall
        cp -r dist $out
        runHook postInstall
      '';
    };

    vst3sdk = fetchFromGitHub {
      owner = "steinbergmedia";
      repo = "vst3sdk";
      rev = "v3.8.0_build_66";
      fetchSubmodules = true;
      hash = "sha256-9HnDOOiKT0ploNJukk4vcZjBLS5gL4SdvmfFqZJPIxA=";

      postFetch = ''
        rm -rf $out/doc
      '';
    };
  };

  meta = {
    description = "VST3 audio plugin suite and successor to Calf Studio Gear";
    homepage = "https://calfnxt.org";
    changelog = "https://github.com/boomshop/calfnxt/releases/tag/v${finalAttrs.version}";
    license = lib.licenses.gpl3Plus;
    maintainers = [ lib.maintainers.stefanboca ];
    platforms = lib.platforms.linux;
  };
})
