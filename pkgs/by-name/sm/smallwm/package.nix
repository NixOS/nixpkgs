{
  lib,
  stdenv,
  fetchFromGitHub,
  doxygen,
  graphviz,
  libX11,
  libXrandr,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "smallwm";
  version = "unstable-2020-02-28";

  src = fetchFromGitHub {
    owner = "adamnew123456";
    repo = "SmallWM";
    rev = "c2dc72afa87241bcf7e646630f4aae216ce78613";
    hash = "sha256-6FPpw1HE0iV/ayl2NvVUApqUcwBElRLf9o216gPyEDM=";
  };

  nativeBuildInputs = [
    doxygen
    graphviz
  ];

  buildInputs = [
    libX11
    libXrandr
  ];

  strictDeps = true;

  dontConfigure = true;

  makeFlags = [
    "CC=${stdenv.cc.targetPrefix}cc"
    "CXX=${stdenv.cc.targetPrefix}c++"
  ];

  buildFlags = [
    "all"
    "doc"
  ];

  installPhase = ''
    runHook preInstall

    install -dm755 $out/bin $out/share/doc/smallwm-${finalAttrs.version}
    install -m755 bin/smallwm -t $out/bin
    cp -r README.markdown doc/html doc/latex $out/share/doc/smallwm-${finalAttrs.version}

    runHook postInstall
  '';

  meta = {
    description = "Small X window manager, extended from tinywm";
    homepage = "https://github.com/adamnew123456/SmallWM";
    license = lib.licenses.bsd2;
    mainProgram = "smallwm";
    maintainers = with lib.maintainers; [ AndersonTorres ];
    inherit (libX11.meta) platforms;
  };
})
