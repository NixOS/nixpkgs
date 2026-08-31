{
  lib,
  stdenv,
  darwin,
  fetchzip,
  makeBinaryWrapper,
  graphviz,
  doxygen,
  ocamlPackages,
  dune,
  why3,
  withWP ? true,
  withMarkdown ? true,
  withApron ? true,
  withZeroMQ ? true,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "frama-c";
  version = "33.0";
  slang = "Arsenic";

  __structuredAttrs = true;

  src = fetchzip {
    url = "https://frama-c.com/download/frama-c-${finalAttrs.version}-${finalAttrs.slang}.tar.gz";
    hash = "sha256-QGqEwwyNFEVrUoE179Yz2AR2s5wWbkUrP3EsnQw9Cjo=";
  };

  preConfigure = ''
    substituteInPlace src/dune --replace-fail " bytes " " "
    substituteInPlace Makefile --replace-fail "include ivette/Makefile.installation" ""
  '';

  strictDeps = true;

  nativeBuildInputs = [
    dune
    makeBinaryWrapper
  ]
  ++ (with ocamlPackages; [
    ocaml
    findlib
    menhir
  ])
  ++ lib.optionals stdenv.hostPlatform.isDarwin [
    darwin.sigtool
  ];

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
      wrapProgram $out/bin/frama-c \
        --prefix OCAMLPATH : ${ocamlPath}:$out/lib/
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
      luc65r
    ];
    platforms = lib.platforms.unix;
    mainProgram = "frama-c";
    broken = !lib.versionAtLeast ocamlPackages.ocaml.version "4.14";
  };
})
