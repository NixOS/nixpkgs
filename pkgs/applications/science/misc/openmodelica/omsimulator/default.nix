{
  lib,
  pkg-config,
  boost,
  readline,
  libxml2,
  openmodelica,
  mkOpenModelicaDerivation,
  fetchFromGitHub,
}:
let
  bomc = fetchFromGitHub {
    owner = "OpenModelica";
    repo = "OMBootstrapping";
    rev = "c289e97c41d00939a4a69fe504961b47283a6d8e";
    sha256 = "0f6pvsw300nf1vpyzxy4qq5d0jkb7k0bi328j1pnwg5n81d57n84";
  };
in
mkOpenModelicaDerivation rec {
  pname = "omsimulator";
  omdir = "OMSimulator";
  omdeps = [ openmodelica.omcompiler ];

  nativeBuildInputs = [ pkg-config ];

  buildInputs = [
    readline
    libxml2
    boost
  ];

  env.CFLAGS = toString [
    "-Wno-error=implicit-function-declaration"
  ];

  postPatch = ''
    sed -i 's|omsimulator.skip:|omsimulator.skip: build-dirs|g' Makefile.in
    cat ${./build-dirs.txt} >> Makefile.in
    mkdir -p OMCompiler/Compiler/boot/bomc
    cp -r ${bomc}/. OMCompiler/Compiler/boot/bomc/
    # we don't have to go through the effort of repacking since this file is used
    # to detect if the openmodelica bootstrap sources are already downloaded, but
    # if detected, is not actually used.
    touch OMCompiler/Compiler/boot/bomc/sources.tar.gz
  '';

  meta = with lib; {
    description = "OpenModelica FMI & SSP-based co-simulation environment";
    homepage = "https://openmodelica.org";
    license = licenses.gpl3Only;
    maintainers = with maintainers; [
      balodja
      smironov
    ];
    platforms = platforms.linux;
  };
}
