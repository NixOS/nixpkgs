{
  fetchFromGitHub,
  fetchNpmDeps,
  lib,
  nix-update-script,
  stdenv,

  # nativeBuildInputs
  cmake,
  nodejs,
  npmHooks,
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
  version = "2.17.0";
  __structuredAttrs = true;
  strictDeps = true;

  src = fetchFromGitHub {
    owner = "boomshop";
    repo = "calfnxt";
    tag = "v${finalAttrs.version}";
    hash = "sha256-3z9rrK2QwZ57qezpAxLkpaS7wpwxEVAyBCHOC42y7dM=";
  };

  postPatch = ''
    mkdir -p external
    ln -s $vst3sdk external/vst3sdk
  '';

  npmRoot = "ui";
  npmDeps = fetchNpmDeps {
    inherit (finalAttrs) src;
    sourceRoot = "${finalAttrs.src.name}/ui";
    hash = "sha256-oCVCvik3/sGRESlukXJGTJmHq1/rvqmk1W8UgVQpg4g=";
  };

  nativeBuildInputs = [
    cmake
    nodejs
    npmHooks.npmConfigHook
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
    (lib.cmakeFeature "CALFNXT_VST3_INSTALL_DIR" "lib/vst3")
  ];

  buildFlags = [ "calfnxt-plugins" ];

  env = {
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

  # The helpers live inside VST3 bundles, outside the hook's usual search paths.
  dontWrapGApps = true;

  postFixup = ''
    for helper in "$out"/lib/vst3/*.vst3/Contents/*/calfnxt-web-host{,-gtk4}; do
      if [ -f "$helper" ]; then
        wrapGApp "$helper"
      fi
    done
  '';

  passthru.updateScript = nix-update-script { };

  meta = {
    description = "VST3 audio plugin suite and successor to Calf Studio Gear";
    homepage = "https://calfnxt.org";
    changelog = "https://github.com/boomshop/calfnxt/releases/tag/v${finalAttrs.version}";
    license = lib.licenses.gpl3Plus;
    maintainers = [ lib.maintainers.stefanboca ];
    platforms = lib.platforms.linux;
  };
})
