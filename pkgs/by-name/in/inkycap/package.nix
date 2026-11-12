{
  lib,
  stdenv,
  rustPlatform,
  fetchFromForgejo,
  buildNpmPackage,
  cargo-tauri,
  glib-networking,
  gst_all_1,
  libayatana-appindicator,
  libsecret,
  perl,
  pkg-config,
  tinymist,
  webkitgtk_4_1,
  wrapGAppsHook4,
}:

let
  # from TINYMIST_VERSION in scripts/download-tinymist.sh.
  # developer says it should work with newer version, but no guarantees.
  requiredTinymistVersion = "0.15.2";
in
assert (builtins.compareVersions requiredTinymistVersion tinymist.version) <= 0;

rustPlatform.buildRustPackage (finalAttrs: {
  pname = "inkycap";
  version = "26.10.8";
  __structuredAttrs = true;

  src = fetchFromForgejo {
    domain = "codefloe.com";
    owner = "InkyCap";
    repo = "app";
    tag = "v${finalAttrs.version}";
    hash = "sha256-9+VvDR9bq2PD4n6k2eGN/9g8EpXpiT5402gRaP4ZuLc=";
  };

  cargoRoot = "src-tauri";
  cargoDeps = rustPlatform.fetchCargoVendor {
    inherit (finalAttrs) src cargoRoot;
    hash = "sha256-RiIKrRH71DDo2dy0EdXys/CB7wM3hLYCb+FZRl8Lsv8=";
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

    cp -r ${finalAttrs.finalPackage.passthru.frontend} dist

    # The frontend is already built; drop beforeBuildCommand so the
    # tauri CLI does not re-run `npm run build`
    substituteInPlace src-tauri/tauri.conf.json \
      --replace-fail '"beforeBuildCommand": "npm run build"' "" \
      --replace-fail '"beforeDevCommand": "npm run dev",' '"beforeDevCommand": "npm run dev"'
  '';

  passthru.frontend = buildNpmPackage {
    pname = "inkycap-frontend";
    inherit (finalAttrs) version src;

    npmDepsHash = "sha256-MAFqX8nNW9qFAQp/db0k1OUULwlT8AtP0COz/N6r8qY=";

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
      inherit (finalAttrs.meta)
        changelog
        homepage
        license
        maintainers
        ;
      description = "Frontend assets for InkyCap";
    };
  };

  doCheck = false;

  meta = {
    changelog = "https://codefloe.com/InkyCap/app/releases/tag/v${finalAttrs.version}";
    homepage = "http://inkycap.org/";
    license = lib.licenses.liliq-p-11;
    maintainers = with lib.maintainers; [ luker ];
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
