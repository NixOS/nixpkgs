{
  lib,
  stdenv,
  rustPlatform,
  fetchFromGitHub,
  cef-binary,
  runCommand,
  cmake,
  git,
  ninja,
  makeWrapper,
  gtk3,
  libGL,
  vulkan-loader,
  versionCheckHook,
}:

let
  # The CEF build for the pinned cef crate (154.5.0+154.0.34 is CEF 154.0.34).
  # update.sh sets these from the release's Cargo.lock and https://cef-builds.spotifycdn.com/index.json.
  cefVersion = "154.0.34";
  cefGitRevision = "14c5a08";
  cefChromiumVersion = "154.0.8037.98";
  cefSha1 = "15c91ad767097217b2e82ba8b933fe30b134be69";
  cef =
    (cef-binary.override {
      version = cefVersion;
      gitRevision = cefGitRevision;
      chromiumVersion = cefChromiumVersion;
      srcHashes.x86_64-linux = "sha256-6H4sdjBDct0ouJnOtu+ks1P1JwBZTdw1ioI37AfsZJI=";
    }).overrideAttrs
      (old: {
        # CEF 154 no longer ships libEGL.so and libGLESv2.so, which nixpkgs'
        # cef-binary (151) patches.
        installPhase = lib.concatStringsSep "\n" (
          lib.filter (line: !(lib.hasInfix "libEGL.so" line || lib.hasInfix "libGLESv2.so" line)) (
            lib.splitString "\n" old.installPhase
          )
        );
      });

  # The layout the cef-dll-sys build script expects in CEF_PATH.
  cefPath = runCommand "riptide-cef-path" { } ''
    mkdir $out
    ln -s ${cef}/Release/* ${cef}/Resources/* $out/
    ln -s ${cef}/{CMakeLists.txt,cmake,include,libcef_dll,CREDITS.html} $out/
    echo '{"type":"minimal","name":"cef_binary_${cefVersion}+g${cefGitRevision}+chromium-${cefChromiumVersion}_linux64_minimal.tar.bz2","sha1":"${cefSha1}"}' > $out/archive.json
  '';

  # Chromium's runtime files, which the build copies next to the binary.
  runtimeFiles = [
    "libcef.so"
    "libvk_swiftshader.so"
    "libvulkan.so.1"
    "vk_swiftshader_icd.json"
    "icudtl.dat"
    "v8_context_snapshot.bin"
    "resources.pak"
    "chrome_100_percent.pak"
    "chrome_200_percent.pak"
    "CREDITS.html"
    "locales"
  ];
in
rustPlatform.buildRustPackage (finalAttrs: {
  pname = "riptide";
  version = "0.7.0";
  __structuredAttrs = true;

  src = fetchFromGitHub {
    owner = "joshzcold";
    repo = "riptide";
    tag = "v${finalAttrs.version}";
    hash = "sha256-goNiCePu/H9AgWaRTpxl61L+re0T2Sa/qB/JSzbwWWs=";
  };

  cargoHash = "sha256-v3YWbtozZGi7aPZsN3XbHrVtCZi+MmuqK4mC9LSkDyQ=";
  cargoBuildFlags = [
    "--bin"
    "riptide"
  ];

  nativeBuildInputs = [
    cmake
    ninja
    makeWrapper
  ];
  # cmake and ninja build CEF's C++ wrapper from the cef-dll-sys build script, not here.
  dontUseCmakeConfigure = true;
  dontUseNinjaBuild = true;
  dontUseNinjaInstall = true;
  dontUseNinjaCheck = true;

  env = {
    CEF_PATH = cefPath;
    RT_GIT_COMMIT = finalAttrs.src.tag;
  };

  # The plugin tests install from local git repositories.
  nativeCheckInputs = [ git ];
  # The unit tests of the CEF-free crates; the rest need a display.
  cargoTestFlags = [
    "-p"
    "rt-core"
    "-p"
    "rt-config"
    "-p"
    "rt-storage"
  ];

  # Chromium opens these at run time rather than linking them.
  runtimeLibraries = lib.makeLibraryPath [
    gtk3
    libGL
    vulkan-loader
  ];

  installPhase = ''
    runHook preInstall
    release=target/${stdenv.hostPlatform.rust.rustcTarget}/release
    mkdir -p $out/lib/riptide $out/bin
    cp "$release/riptide" $out/lib/riptide/
    for f in ${lib.escapeShellArgs runtimeFiles}; do
      cp -rL "$release/$f" $out/lib/riptide/
    done
    chmod -R u+w $out/lib/riptide
    # The Nix store can't hold a setuid sandbox helper, so there is none; the
    # sandbox uses user namespaces instead, which NixOS allows by default.
    makeWrapper $out/lib/riptide/riptide $out/bin/riptide \
      --prefix LD_LIBRARY_PATH : "$runtimeLibraries"
    install -Dm644 packaging/riptide.desktop $out/share/applications/riptide.desktop
    install -Dm644 packaging/riptide.svg $out/share/icons/hicolor/scalable/apps/riptide.svg
    runHook postInstall
  '';

  doInstallCheck = true;
  nativeInstallCheckInputs = [ versionCheckHook ];

  # Bumps the version and hashes, and the cef* values above when CEF changes.
  passthru.updateScript = ./update.sh;

  meta = {
    description = "Keyboard-driven web browser with vim-like bindings, built on CEF";
    homepage = "https://joshzcold.github.io/riptide/";
    changelog = "https://github.com/joshzcold/riptide/blob/v${finalAttrs.version}/CHANGELOG.md";
    license = lib.licenses.gpl3Plus;
    mainProgram = "riptide";
    platforms = [ "x86_64-linux" ];
    maintainers = with lib.maintainers; [ joshzcold ];
  };
})
