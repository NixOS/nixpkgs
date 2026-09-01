{
  lib,
  stdenv,
  rustPlatform,
  fetchFromCodeberg,
  buildNpmPackage,
  cargo-tauri,
  glib-networking,
  gst_all_1,
  libayatana-appindicator,
  libsecret,
  nodejs,
  perl,
  pkg-config,
  tinymist,
  webkitgtk_4_1,
  wrapGAppsHook4,
}:

let
  version = "26.9.2";
  src = fetchFromCodeberg {
    owner = "InkyCap";
    repo = "app";
    rev = "v${version}";
    hash = "sha256-sBdjtQ31dtC1upJanJoQISOYrUJDAqjx0SUvHODSEUQ=";
  };
  changelog = "https://codeberg.org/InkyCap/app/releases/tag/v${version}";
  homepage = "http://inkycap.org/";
  license = lib.licenses.liliq-p-11;
  maintainers = with lib.maintainers; [ luker ];

  # from TINYMIST_VERSION in scripts/download-tinymist.sh.
  # developer says it should work with newer version, but no guarantees.
  requiredTinymistVersion = "0.15.2";

  frontend = buildNpmPackage (finalAttrs: {
    pname = "inkycap-frontend";
    inherit version src;

    npmDepsHash = "sha256-vXf4W3U5EIzqHRdUkIy1z+0+umMbR1AflQ31pJCo37M=";

    # The npm hook installs with `npm ci --ignore-scripts`, so the
    # postinstall script (patch-package) never runs. Apply the patches
    # from patches/ explicitly, before the bundle.
    preBuild = ''
      ./node_modules/.bin/patch-package
    '';

    installPhase = ''
      runHook preInstall
      cp -r dist $out
      runHook postInstall
    '';

    meta = {
      inherit
        changelog
        homepage
        license
        maintainers
        ;
      description = "Frontend assets for InkyCap";
    };
  });
in
assert (builtins.compareVersions requiredTinymistVersion tinymist.version) <= 0;

rustPlatform.buildRustPackage (finalAttrs: {
  pname = "inkycap";
  inherit version src;

  __structuredAttrs = true;

  cargoRoot = "src-tauri";
  cargoDeps = rustPlatform.fetchCargoVendor {
    inherit (finalAttrs) src cargoRoot;
    hash = "sha256-0vM6eA9+4I5EawZD2iSsbPYsfkiRFjuEH28YQ772bpY=";
  };
  buildAndTestSubdir = "src-tauri";

  nativeBuildInputs = [
    cargo-tauri.hook
    pkg-config
    perl
    wrapGAppsHook4
  ];

  buildInputs = [
    glib-networking
    gst_all_1.gst-plugins-base
    gst_all_1.gst-plugins-bad
    gst_all_1.gst-plugins-good
    gst_all_1.gst-libav
    libayatana-appindicator
    libsecret
    webkitgtk_4_1
  ];

  postPatch = ''
    # Tauri expects sidecars as binaries/<name>-<triple>.
    # make sure nixpkgs version and package version are synchronized
    install -Dm755 ${tinymist}/bin/tinymist \
      "src-tauri/binaries/inkycap-tinymist-${stdenv.hostPlatform.rust.rustcTargetSpec}"

    cp -r ${frontend} dist

    # The frontend is already built; drop beforeBuildCommand so the
    # tauri CLI does not re-run `npm run build`
    substituteInPlace src-tauri/tauri.conf.json \
      --replace-fail '"beforeBuildCommand": "npm run build"' "" \
      --replace-fail '"beforeDevCommand": "npm run dev",' '"beforeDevCommand": "npm run dev"'
  '';

  doCheck = false;

  meta = {
    inherit
      changelog
      homepage
      license
      maintainers
      ;
    description = "Personal knowledge management (PKM) tool that uses Typst markup";
    longDescription = ''
      InkyCap is a personal knowledge management tool that helps you explore
      ideas and write. Tailored for academic workflows, research, writing,
      task and date awareness; InkyCap provides flexible ways to organize
      your information.
    '';
    platforms = lib.platforms.linux;
    mainProgram = "inkycap";
  };
})
