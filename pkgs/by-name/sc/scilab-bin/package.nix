{
  lib,
  stdenv,
  fetchurl,
  makeWrapper,
  undmg,
  autoPatchelfHook,
  alsa-lib,
  ncurses5,
  xorg,
  libgbm,
  expat,
  libxkbcommon,
  pango,
  cairo,
  systemd,
  at-spi2-core,
  nss,
  nspr,
  cups,
}:

let
  pname = "scilab-bin";
  version = "2026.0.0";

  srcs = {
    aarch64-darwin = fetchurl {
      url = "https://www.scilab.org/download/${version}/scilab-${version}-arm64.dmg";
      sha256 = "sha256-omfxtzQfkwmApDxbGlTKnzcptfdhjFJRlwW9oGWw1Ko=";
    };
    x86_64-darwin = fetchurl {
      url = "https://www.scilab.org/download/${version}/scilab-${version}-x86_64.dmg";
      sha256 = "sha256-avnob3gFVS/6yMQnb6NBeKeQogX8n6hJIWijSQEGbxs=";
    };
    x86_64-linux = fetchurl {
      url = "https://www.scilab.org/download/${version}/scilab-${version}.bin.x86_64-linux-gnu.tar.xz";
      sha256 = "sha256-gAtaj1weThztFhjiRbfmqdQg0XMquU6LX5E/BeG+ilc=";
    };
  };
  src =
    srcs.${stdenv.hostPlatform.system} or (throw "Unsupported system: ${stdenv.hostPlatform.system}");

  meta = {
    homepage = "http://www.scilab.org/";
    description = "Scientific software package for numerical computations (Matlab lookalike)";
    platforms = [
      "aarch64-darwin"
      "x86_64-darwin"
      "x86_64-linux"
    ];
    sourceProvenance = with lib.sourceTypes; [ binaryNativeCode ];
    license = lib.licenses.gpl2Only;
    mainProgram = "scilab";
  };

  darwin = stdenv.mkDerivation {
    inherit
      pname
      version
      src
      meta
      ;

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

    dontCheckForBrokenSymlinks = true;
  };

  linux = stdenv.mkDerivation {
    inherit
      pname
      version
      src
      meta
      ;

    nativeBuildInputs = [ autoPatchelfHook ];

    buildInputs = [
      alsa-lib
      ncurses5
      stdenv.cc.cc
      # for JCEF
      libgbm
      expat
      libxkbcommon
      pango
      cairo
      systemd
      at-spi2-core
      nss
      nspr
      cups
    ]
    ++ (with xorg; [
      libX11
      libXext
      libXi
      libXrender
      libXtst
      libXxf86vm
      libXrandr
      libXcursor
      libXcomposite
      libXdamage
    ]);

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

    dontCheckForBrokenSymlinks = true;
  };
in
if stdenv.hostPlatform.isDarwin then darwin else linux
