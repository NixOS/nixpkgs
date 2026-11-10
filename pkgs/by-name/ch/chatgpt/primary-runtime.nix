{
  lib,
  stdenv,
  fetchurl,
  autoPatchelfHook,
  bash,
  gitMinimal,
  jq,
  curl,
  expat,
  fontconfig,
  freetype,
  icu,
  lcms2,
  libjpeg,
  libpng,
  libxcrypt-legacy,
  libxml2,
  nspr,
  nss,
  openjpeg,
  pixman,
  zlib,

  source,
  sources,
}:
let
  inherit (stdenv.hostPlatform.node) arch platform;
in
stdenv.mkDerivation (finalAttrs: {
  pname = "chatgpt-primary-runtime";
  inherit (source.primaryRuntime) version;
  src = fetchurl source.primaryRuntime.src;

  nativeBuildInputs = [
    autoPatchelfHook
    jq
  ];
  buildInputs = [
    stdenv.cc.cc.lib
    curl
    expat
    fontconfig
    freetype
    icu
    lcms2
    libjpeg
    libpng
    libxcrypt-legacy
    libxml2
    nspr
    nss
    openjpeg
    pixman
    zlib
  ];

  # Sorting ELF program headers makes the bundled Node segfault.
  patchelfFlags = [ "--no-sort" ];
  dontBuild = true;
  dontStrip = true;
  strictDeps = true;

  installPhase = ''
    runHook preInstall

    root="$out/lib/codex-primary-runtime"
    mkdir -p "$root"
    cp -a . "$root/"
    jq -e --arg version ${lib.escapeShellArg finalAttrs.version} \
      --arg platform ${lib.escapeShellArg platform} --arg arch ${lib.escapeShellArg arch} \
      '.bundleVersion == $version and .targetPlatform == $platform and .targetArch == $arch' \
      "$root/runtime.json"

    # Bundled Git requires Debian's libcurl-gnutls ABI, which Nixpkgs does not provide.
    rm -r "$root/dependencies/native/git"
    rm "$root/dependencies/bin/fallback/git"
    ln -s ${lib.getExe gitMinimal} "$root/dependencies/bin/fallback/git"
    find "$root" \
      \( -name 'libstdc++.so*' -o -name 'libgcc_s.so*' \) -delete

    # Share ABI-compatible libraries with Nixpkgs; retain LibreOffice's patched libraries.
    # Keep libjpeg.so.8 because Nixpkgs provides libjpeg.so.62.
    find "$root/dependencies/native" \
      \( -name 'libexpat.so*' \
      -o -name 'libfontconfig.so*' \
      -o -name 'libfreetype.so*' \
      -o -name 'libicudata.so*' \
      -o -name 'libicui18n.so*' \
      -o -name 'libicuuc.so*' \
      -o -name 'liblcms2.so*' \
      -o -name 'libopenjp2.so*' \
      -o -name 'libpixman-1.so*' \
      -o -name 'libpng16.so*' \
      -o -name 'libxml2.so*' \
      -o -name 'libz.so*' \) -delete

    HOST_PATH="$root/dependencies/python/bin:$root/dependencies/node/bin:${lib.makeBinPath [ bash ]}" \
      patchShebangs --host "$root"
    runHook postInstall
  '';

  meta = {
    description = "Workspace runtime bundled with ChatGPT";
    homepage = "https://developers.openai.com/codex/app";
    license = lib.licenses.unfree;
    platforms = lib.attrNames (
      lib.filterAttrs (system: value: (value.primaryRuntime or null) != null) sources
    );
    sourceProvenance = [ lib.sourceTypes.binaryNativeCode ];
  };
})
