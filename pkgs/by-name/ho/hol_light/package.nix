{
  lib,
  stdenv,
  fetchFromGitHub,
  makeBinaryWrapper,
  writeText,
  ocamlPackages,
  ledit,
  bash,
}:

let
  inherit (ocamlPackages)
    ocaml
    findlib
    zarith
    camlp5
    camlp-streams
    fmt
    pcre2
    ;
in

let
  ocamlPath = lib.makeSearchPath "/lib/ocaml/${ocaml.version}/site-lib" [
    camlp5
    camlp-streams
    fmt
    pcre2
    zarith
  ];
  stublibsPath = lib.makeSearchPath "/lib/ocaml/${ocaml.version}/site-lib/stublibs" [
    zarith
    pcre2
  ];
in

stdenv.mkDerivation {
  pname = "hol_light";
  version = "0-unstable-2026-05-19";

  src = fetchFromGitHub {
    owner = "jrh13";
    repo = "hol-light";
    rev = "9b510bc76da4cecf6e509be44d327c9236ec273f";
    hash = "sha256-QaTDrGHpHvEde2AK/SD7eM+bAC9vN5o+dQqW1oau1Yo=";
  };

  patches = [
    # Accept camlp5 8.05 in the pa_j chooser; submitted upstream.
    ./0001-pa_j-accept-camlp5-8.05-for-OCaml-5.4.patch
    # Link findlib into ocaml-hol so `#use "topfind"` works in the sandbox.
    ./0002-link-findlib-into-ocaml-hol.patch
  ];

  strictDeps = true;

  nativeBuildInputs = [
    ocaml
    findlib
    camlp5
    makeBinaryWrapper
  ];
  buildInputs = [
    bash
    ocaml
    findlib
    camlp5
    ledit
  ];
  propagatedBuildInputs = [
    camlp-streams
    fmt
    pcre2
    zarith
  ];

  setupHook = writeText "hol-light-setup-hook.sh" ''
    addHolLight () {
      if test -d "''$1/lib/hol_light"; then
        export HOLLIGHT_DIR="''$1/lib/hol_light"
      fi
    }
    addEnvHooks "$targetOffset" addHolLight
  '';

  buildPhase = ''
    runHook preBuild
    patchShebangs .
    HOLLIGHT_USE_MODULE=1 make hol.sh
    HOLLIGHT_USE_MODULE=1 make
    runHook postBuild
  '';

  installPhase = ''
    runHook preInstall
    mkdir -p "$out/lib/hol_light"
    cp -a . "$out/lib/hol_light"
    # The Makefile bakes the build directory into hol.sh; regenerate it
    # pointing at the install location.
    sed "s^__DIR__^$out/lib/hol_light^g; s^__USE_MODULE__^1^g" hol_4.14.sh \
      > "$out/lib/hol_light/hol.sh"
    chmod +x "$out/lib/hol_light/hol.sh"
    # Add the findlib site-lib so the toplevel can `#use "topfind"`.
    substituteInPlace "$out/lib/hol_light/hol.sh" \
      --replace-fail '-init ''${HOL_ML_PATH} -I ''${HOLLIGHT_DIR}' \
        '-init ''${HOL_ML_PATH} -I ''${HOLLIGHT_DIR} -I ${findlib}/lib/ocaml/${ocaml.version}/site-lib'
    makeWrapper "$out/lib/hol_light/hol.sh" "$out/bin/hol_light" \
      --prefix PATH : ${
        lib.makeBinPath [
          ocaml
          findlib
          camlp5
          ledit
        ]
      } \
      --set OCAMLPATH "${ocamlPath}" \
      --prefix CAML_LD_LIBRARY_PATH : "${stublibsPath}"
    ln -s hol_light "$out/bin/hol.sh"
    runHook postInstall
  '';

  meta = {
    description = "Interactive theorem prover based on Higher-Order Logic";
    homepage = "http://www.cl.cam.ac.uk/~jrh13/hol-light/";
    mainProgram = "hol_light";
    license = lib.licenses.bsd2;
    platforms = lib.platforms.unix;
    maintainers = with lib.maintainers; [
      thoughtpolice
      vbgl
      mkannwischer
    ];
  };
}
