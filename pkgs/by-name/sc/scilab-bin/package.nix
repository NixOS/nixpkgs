{
  lib,
  stdenv,
  fetchurl,
  makeWrapper,
  undmg,
  autoPatchelfHook,
  testers,
  alsa-lib,
  libgbm,
  zlib,
  glib,
  nss,
  nspr,
  dbus,
  at-spi2-core,
  cups,
  expat,
  pango,
  cairo,
  udev,

  libxkbcommon,
  libxfixes,
  libxcb,
  libx11,
  libxext,
  libxi,
  libxrender,
  libxtst,
  libxxf86vm,
  libxrandr,
  libxcursor,
  libxcomposite,
  libxdamage,
  fontconfig,
  freetype,
  libGL,
  gtk3,
}:

let
  pname = "scilab-bin";
  version = "2026.1.0";

  srcs = {
    aarch64-darwin = fetchurl {
      url = "https://www.scilab.org/download/${version}/scilab-${version}-arm64.dmg";
      sha256 = "sha256-qG5osaeUiPEkUHu8q4lr+zhkxhpbHOlxVa1dSYRGOLc=";
    };
    x86_64-linux = fetchurl {
      url = "https://www.scilab.org/download/${version}/scilab-${version}.bin.x86_64-linux-gnu.tar.xz";
      sha256 = "sha256-lncn1r5QfxO1Kss2jj/UAfCr7MKfLJIAlMs6maBAvck=";
    };
  };
  src =
    srcs.${stdenv.hostPlatform.system} or (throw "Unsupported system: ${stdenv.hostPlatform.system}");

  meta = {
    homepage = "http://www.scilab.org/";
    description = "Scientific software package for numerical computations (Matlab lookalike)";
    platforms = [
      "aarch64-darwin"
      "x86_64-linux"
    ];
    sourceProvenance = with lib.sourceTypes; [ binaryNativeCode ];
    license = lib.licenses.gpl2Only;
    mainProgram = "scilab";
    changelog = "https://help.scilab.org/docs/${version}/en_US/CHANGES.html";
  };

  darwin = stdenv.mkDerivation (finalAttrs: {
    inherit
      pname
      version
      src
      meta
      ;

    __structuredAttrs = true;
    strictDeps = true;

    nativeBuildInputs = [
      makeWrapper
      undmg
    ];

    sourceRoot = "scilab-${version}.app";

    installPhase = ''
      runHook preInstall

      mkdir -p $out/{Applications/scilab.app,bin}
      cp -R . $out/Applications/scilab.app
      makeWrapper $out/{Applications/scilab.app/Contents/MacOS,bin}/scilab

      runHook postInstall
    '';
  });

  linux = stdenv.mkDerivation (finalAttrs: {
    inherit
      pname
      version
      src
      meta
      ;

    __structuredAttrs = true;
    strictDeps = true;

    nativeBuildInputs = [
      autoPatchelfHook
      makeWrapper
    ];

    buildInputs = [
      alsa-lib
      stdenv.cc.cc
      libgbm
      zlib
      glib
      nss
      nspr
      dbus
      at-spi2-core
      cups
      expat
      pango
      cairo
      udev

      libxkbcommon
      libxfixes
      libxcb
      libx11
      libxext
      libxi
      libxrender
      libxtst
      libxxf86vm
      libxrandr
      libxcursor
      libxcomposite
      libxdamage
    ];

    installPhase = ''
      runHook preInstall

      mkdir -p $out
      mv -t $out bin include lib share thirdparty
      sed -i \
        -e 's|\$(/bin/|$(|g' \
        -e 's|/usr/bin/||g' \
        $out/bin/{scilab,xcos}
      sed -i \
        -e "s|Exec=|Exec=$out/bin/|g" \
        -e "s|Terminal=.*$|Terminal=true|g" \
        $out/share/applications/*.desktop

      runHook postInstall
    '';

    postFixup = ''
      for f in scilab-bin scilab-cli-bin; do
        wrapProgram $out/bin/$f \
          --prefix LD_LIBRARY_PATH : ${
            lib.makeLibraryPath [
              libGL
              fontconfig
              freetype
              gtk3
            ]
          }
      done
    '';

    # A small version test for scilab
    passthru.tests.version = testers.testVersion {
      package = finalAttrs.finalPackage;
      command = "scilab -version";
    };
  });
in
if stdenv.hostPlatform.isDarwin then darwin else linux
