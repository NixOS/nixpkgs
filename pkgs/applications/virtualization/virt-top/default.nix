{
  lib,
  stdenv,
  fetchgit,
  ocamlPackages,
  autoreconfHook,
  libxml2,
  pkg-config,
  getopt,
  gettext,
}:

stdenv.mkDerivation rec {
  pname = "virt-top";
  version = "1.1.2";

  src = fetchgit {
    url = "git://git.annexia.org/virt-top.git";
    rev = "v${version}";
    hash = "sha256-C1a47pWtjb38bnwmZ2Zq7/LlW3+BF5BGNMRFi97/ngU=";
  };

  patches = [
    ./gettext-0.25.patch
  ];

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

  postPatch = ''
    substituteInPlace ocaml-dep.sh.in --replace-fail '#!/bin/bash' '#!${stdenv.shell}'
    substituteInPlace ocaml-link.sh.in --replace-fail '#!/bin/bash' '#!${stdenv.shell}'
    substituteInPlace configure.ac --replace-fail 'AC_CONFIG_MACRO_DIR([m4])' 'AC_CONFIG_MACRO_DIRS([m4 ${gettext}/share/gettext/m4])'
  '';

  meta = {
    description = "Top-like utility for showing stats of virtualized domains";
    homepage = "https://people.redhat.com/~rjones/virt-top/";
    license = lib.licenses.gpl2Only;
    maintainers = [ ];
    platforms = lib.platforms.linux;
    mainProgram = "virt-top";
  };
}
