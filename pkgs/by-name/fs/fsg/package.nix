{
  lib,
  stdenv,
  fetchurl,
  gtk2,
  glib,
  pkg-config,
  libGLU,
  libGL,
  wxGTK32,
  libX11,
  xorgproto,
  runtimeShell,
}:

stdenv.mkDerivation rec {
  pname = "fsg";
  version = "4.4";

  src = fetchurl {
    name = "fsg-src-${version}.tar.gz";
    url = "https://raw.githubusercontent.com/ctrlcctrlv/wxsand/5716c16b655ca3670e7acd76372b43763bec20d1/fsg-src-${version}-ORIGINAL.tar.gz";
    sha256 = "1756y01rkvd3f1pkj88jqh83fqcfl2fy0c48mcq53pjzln9ycv8c";
  };

  patches = [ ./wxgtk-3.2.patch ];

  # use correct wx-config for cross-compiling
  postPatch = ''
    substituteInPlace makefile \
      --replace-fail 'wx-config' "${lib.getExe' wxGTK32 "wx-config"}"
  '';

  hardeningDisable = [ "format" ];

  nativeBuildInputs = [ pkg-config ];

  buildInputs = [
    glib
    libGLU
    libGL
    wxGTK32
    libX11
    xorgproto
  ];

  preBuild = ''
    sed -e '
      s@currentProbIndex != 100@0@;
    ' -i MainFrame.cpp
    sed -re '/ctrans_prob/s/energy\[center][+]energy\[other]/(int)(fmin(energy[center]+energy[other],99))/g' -i Canvas.cpp
  '';

  makeFlags = [
    "CPP=${stdenv.cc.targetPrefix}c++"
  ];

  installPhase = ''
    mkdir -p $out/bin $out/libexec
    cp sand $out/libexec
    echo -e '#!${runtimeShell}\nLC_ALL=C '$out'/libexec/sand "$@"' >$out/bin/fsg
    chmod a+x $out/bin/fsg
  '';

  meta = {
    description = "Cellular automata engine tuned towards the likes of Falling Sand";
    mainProgram = "fsg";
    maintainers = [ lib.maintainers.raskin ];
    platforms = lib.platforms.linux;
  };
}
