{
  lib,
  stdenv,
  fetchurl,
  graphviz,
  doxygen,
  ocamlPackages,
  coq,
  dune,
  why3,
  gdk-pixbuf,
  wrapGAppsHook3,
  withGui ? true,
  withWP ? true,
  withMarkdown ? true,
  withApron ? true,
  withZeroMQ ? true,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "frama-c";
  version = "32.1";
  slang = "Germanium";

  __structuredAttrs = true;

  src = fetchurl {
    url = "https://frama-c.com/download/frama-c-${finalAttrs.version}-${finalAttrs.slang}.tar.gz";
    hash = "sha256-3V1uid9d3mpAs4vq0wLQpbmGCxw7ZbzYU2CneAh8E+I=";
  };

  preConfigure = ''
    substituteInPlace src/dune --replace-warn " bytes " " "
    substituteInPlace Makefile --replace-warn "include ivette/Makefile.installation" ""
  '';

  strictDeps = true;

  nativeBuildInputs = [
    wrapGAppsHook3
    dune
  ]
  ++ (with ocamlPackages; [
    ocaml
    findlib
    menhir
  ]);

  buildInputs =
    with ocamlPackages;
    [
      camlzip
      dune-configurator
      dune-site
      menhirLib
      ocamlgraph
      ppx_deriving
      ppx_deriving_yaml
      ppx_inline_test
      unionFind
      yojson
      zarith
    ]
    ++ lib.optionals withGui [
      lablgtk3
      lablgtk3-sourceview3
    ]
    ++ lib.optionals withWP [
      why3
    ]
    ++ lib.optionals withMarkdown [
      ppx_deriving_yojson
    ]
    ++ lib.optionals withApron [
      apron
    ]
    ++ lib.optionals withZeroMQ [
      zmq
    ];

  buildPhase = ''
    runHook preBuild
    dune build ''${enableParallelBuilding:+-j $NIX_BUILD_CORES} --release @install
    runHook postBuild
  '';

  installFlags = [ "PREFIX=$(out)" ];

  preFixup =
    let
      runtimeDeps =
        with ocamlPackages;
        finalAttrs.buildInputs
        ++ [
          bigarray-compat
          mlgmpidl
          parsexp
          re
          seq
          sexplib
        ]
        ++ lib.optionals withWP [
          why3.dev
        ]
        ++ lib.optionals withApron [
          apron.dev
        ];

      ocamlPath = lib.makeSearchPath "/lib/ocaml/${ocamlPackages.ocaml.version}/site-lib" runtimeDeps;
    in
    ''
      gappsWrapperArgs+=(--prefix OCAMLPATH ':' ${ocamlPath}:$out/lib/)
    '';

  meta = {
    description = "Extensible and collaborative platform dedicated to source-code analysis of C software";
    longDescription = ''
      Frama-C is an open-source extensible and collaborative platform
      dedicated to source-code analysis of C software. The Frama-C
      analyzers assist you in various source-code-related activities,
      from the navigation through unfamiliar projects up to the
      certification of critical software.
    '';
    homepage = "https://www.frama-c.com/index.html";
    license = lib.licenses.lgpl21;
    maintainers = with lib.maintainers; [
      thoughtpolice
      amiddelk
      luc65r
    ];
    platforms = lib.platforms.unix;
    mainProgram = "frama-c";
    broken = !lib.versionAtLeast ocamlPackages.ocaml.version "4.14";
  };
})
