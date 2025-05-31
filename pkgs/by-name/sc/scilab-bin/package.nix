{
  lib,
  stdenv,
  fetchurl,
  makeWrapper,
  undmg,
  autoPatchelfHook,
  alsa-lib,
  ncurses5,
  libgbm,
  xorg,
}:

let
  pname = "scilab-bin";
  version = "2025.0.0";

  srcs = {
    aarch64-darwin = fetchurl {
      url = "https://www.scilab.org/download/${version}/scilab-${version}-arm64.dmg";
      hash = "sha256-hQFETzQiguqiVKBuIrce62eYEJ066B1lHN0IejNUaPQ=";
    };
    x86_64-darwin = fetchurl {
      url = "https://www.scilab.org/download/${version}/scilab-${version}-x86_64.dmg";
      hash = "sha256-0CrmJfjTt7Gko6etBnH9YULtqwwB7pDYHDwE/akuWuA=";
    };
    x86_64-linux = fetchurl {
      url = "https://www.scilab.org/download/${version}/scilab-${version}.bin.x86_64-linux-gnu.tar.xz";
      hash = "sha256-905HpjpNWnupJ7/fl0Xj7ePDpeMVi02OnEyIeawNdxw=";
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

    nativeBuildInputs = [
      autoPatchelfHook
    ];

    buildInputs =
      [
        alsa-lib
        ncurses5
        stdenv.cc.cc
        libgbm
      ]
      ++ (with xorg; [
        libX11
        libXcursor
        libXext
        libXft
        libXi
        libXrandr
        libXrender
        libXtst
        libXxf86vm
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
