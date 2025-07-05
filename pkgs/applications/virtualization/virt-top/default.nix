{
  lib,
  stdenv,
  fetchgit,
  ocamlPackages,
  autoreconfHook,
  libxml2,
  pkg-config,
  getopt,
}:

stdenv.mkDerivation rec {
  pname = "virt-top";
  version = "1.1.2";

  src = fetchgit {
    url = "git://git.annexia.org/virt-top.git";
    rev = "v${version}";
    hash = "sha256-C1a47pWtjb38bnwmZ2Zq7/LlW3+BF5BGNMRFi97/ngU=";
  };

  strictDeps = true;

  nativeBuildInputs = [
    autoreconfHook
    pkg-config
    getopt
    ocamlPackages.ocaml
    ocamlPackages.findlib
  ];
  buildInputs =
    with ocamlPackages;
    [
      ocamlPackages.ocaml
      calendar
      curses
      gettext-stub
      ocaml_libvirt
    ]
    ++ [ libxml2 ];

  prePatch = ''
    substituteInPlace ocaml-dep.sh.in --replace '#!/bin/bash' '#!${stdenv.shell}'
    substituteInPlace ocaml-link.sh.in --replace '#!/bin/bash' '#!${stdenv.shell}'
  '';

  meta = with lib; {
    description = "Top-like utility for showing stats of virtualized domains";
    homepage = "https://people.redhat.com/~rjones/virt-top/";
    license = licenses.gpl2Only;
    maintainers = [ ];
    platforms = platforms.linux;
    mainProgram = "virt-top";
  };
}
