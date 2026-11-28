{ lib
, stdenv
, fetchFromGitHub
, autoreconfHook
, pkg-config
, bison
, flex
, perl
, python3
, libsForQt5
, libxml2
, zlib
, webkitgtk
, gnumake
, openscenegraph
}:

let
  python3-with-packages = python3.withPackages (ps: with ps; [ numpy pandas matplotlib scipy seaborn posix_ipc ]);
in
stdenv.mkDerivation rec {
  pname = "OMNeT++";
  version = "6.0.2";

  src = fetchFromGitHub {
    owner = "omnetpp";
    repo = "omnetpp";
    rev = "omnetpp-${version}";
    hash = "sha256-hxjPYu9W+KlJuttCWS7ooxCMIP2CIKZP4+crt47Yhz4=";
  };

  nativeBuildInputs = [
    autoreconfHook
    gnumake
    pkg-config
    bison
    flex
    perl
    python3-with-packages
    libsForQt5.wrapQtAppsHook
  ];

  buildInputs = [
    libsForQt5.qtbase
    libxml2
    zlib
    webkitgtk
    openscenegraph
  ];

  postPatch = ''
    cp configure.user.dist configure.user
    source setenv
    patchShebangs --build src/utils/*
  '';

  makeFlags = [ "MODE=release" ];

  installPhase = ''
    runHook preInstall

    mkdir -p $out/{bin,lib}

    mv lib/* $out/lib/

    cp ${src}/setenv $out/
    mv bin/* $out/bin/
    chmod +x $out/setenv
    cp configure.user Makefile.inc ${src}/Version $out/
    cp -r ${src}/include $out/

    runHook postInstall
  '';

  strictDeps = true;
  enableParallelBuilding = true;

  meta = {
    homepage = "https://omnetpp.org/";
    description = "Extensible, modular, component-based C++ simulation library and framework, primarily for building network simulators";
    changelog = "https://github.com/omnetpp/omnetpp/blob/master/WHATSNEW.md";
    license = lib.licenses.unfree; # technically, the "Academic Public License"
    maintainers = with lib.maintainers; [ ];
    mainProgram = "omnetpp";
    platforms = lib.platforms.linux;
  };
}
