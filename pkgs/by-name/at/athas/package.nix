{
  lib,
  stdenv,
  fetchurl,
  autoPatchelfHook,
  makeWrapper,
  wrapGAppsHook3,
  nix-update-script,
  glib,
  gtk3,
  gdk-pixbuf,
  cairo,
  pango,
  atk,
  at-spi2-core,
  nss,
  nspr,
  dbus,
  cups,
  expat,
  zlib,
  xz,
  alsa-lib,
  libxkbcommon,
  libgbm,
  mesa,
  libGL,
  libdrm,
  fontconfig,
  freetype,
  systemdLibs,
  libx11,
  libxcb,
  libxcomposite,
  libxdamage,
  libxext,
  libxfixes,
  libxrandr,
  libxrender,
  libxcursor,
  libxi,
  libxtst,
  libxscrnsaver,
  libxshmfence,
}:

let
  # Prebuilt Linux release tarballs published by upstream. Athas bundles a
  # CEF/Chromium runtime, so building from source in nixpkgs is impractical;
  # the release artifacts are wrapped instead.
  sources = {
    x86_64-linux = {
      arch = "x86_64";
      hash = "sha256-0E+N59njEy3n3QAnUTBTH3p5fELFEnt/caBAOshiT+Y=";
    };
    aarch64-linux = {
      arch = "aarch64";
      hash = "sha256-kRGg6rWkB6xE+y8K8qn9xouAklixSHODOXc1bPdGcXE=";
    };
  };

  source =
    sources.${stdenv.hostPlatform.system}
      or (throw "athas: unsupported system ${stdenv.hostPlatform.system}");

  runtimeLibs = [
    glib
    gtk3
    gdk-pixbuf
    cairo
    pango
    atk
    at-spi2-core
    nss
    nspr
    dbus
    cups
    expat
    zlib
    xz
    alsa-lib
    libxkbcommon
    libgbm
    mesa
    libGL
    libdrm
    fontconfig
    freetype
    systemdLibs
    libx11
    libxcb
    libxcomposite
    libxdamage
    libxext
    libxfixes
    libxrandr
    libxrender
    libxcursor
    libxi
    libxtst
    libxscrnsaver
    libxshmfence
  ];
in
stdenv.mkDerivation (finalAttrs: {
  pname = "athas";
  version = "0.7.2";

  src = fetchurl {
    url = "https://github.com/athasdev/athas/releases/download/v${finalAttrs.version}/Athas_${finalAttrs.version}_linux-${source.arch}.tar.gz";
    inherit (source) hash;
  };

  sourceRoot = "athas.app";

  strictDeps = true;
  __structuredAttrs = true;

  nativeBuildInputs = [
    autoPatchelfHook
    makeWrapper
    wrapGAppsHook3
  ];

  buildInputs = runtimeLibs;

  dontWrapGApps = true;

  # chrome-sandbox needs a setuid bit that the Nix store cannot provide; the
  # launcher runs with --no-sandbox, so Vulkan is disabled and skipped during
  # autoPatchelf too.
  autoPatchelfIgnoreMissingDeps = [ "libvulkan.so.1" ];

  installPhase = ''
    runHook preInstall

    mkdir -p $out/libexec $out/lib $out/share
    cp -r libexec/. $out/libexec/
    cp -r lib/. $out/lib/
    cp -r share/. $out/share/

    makeWrapper $out/libexec/athas $out/bin/athas \
      --add-flags "--no-sandbox --ozone-platform=x11 --disable-vulkan --disable-features=Vulkan" \
      --prefix LD_LIBRARY_PATH : "$out/libexec:${lib.makeLibraryPath runtimeLibs}" \
      "''${gappsWrapperArgs[@]}"

    runHook postInstall
  '';

  passthru.updateScript = nix-update-script { };

  meta = {
    description = "Fast and extensible code editor";
    homepage = "https://github.com/athasdev/athas";
    changelog = "https://github.com/athasdev/athas/releases/tag/v${finalAttrs.version}";
    license = lib.licenses.agpl3Only;
    sourceProvenance = with lib.sourceTypes; [ binaryNativeCode ];
    maintainers = with lib.maintainers; [ _0x4bs3nt ];
    mainProgram = "athas";
    platforms = [
      "x86_64-linux"
      "aarch64-linux"
    ];
  };
})
