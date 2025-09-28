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
}:

let
  pname = "scilab-bin";
  version = "6.1.1";

  srcs = {
    aarch64-darwin = fetchurl {
      url = "https://www.utc.fr/~mottelet/scilab/download/${version}/scilab-${version}-accelerate-arm64.dmg";
      sha256 = "sha256-L4dxD8R8bY5nd+4oDs5Yk0LlNsFykLnAM+oN/O87SRI=";
    };
    x86_64-darwin = fetchurl {
      url = "https://www.utc.fr/~mottelet/scilab/download/${version}/scilab-${version}-x86_64.dmg";
      sha256 = "sha256-tBeqzllMuogrGcJxGqEl2DdNXaiwok3yhzWSdlWY5Fc=";
    };
    x86_64-linux = fetchurl {
      url = "https://www.scilab.org/download/${version}/scilab-${version}.bin.linux-x86_64.tar.gz";
      sha256 = "sha256-PuGnz2YdAhriavwnuf5Qyy0cnCeRHlWC6dQzfr7bLHk=";
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

    buildInputs = [
      alsa-lib
      ncurses5
      stdenv.cc.cc
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
