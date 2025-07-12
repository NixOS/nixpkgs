{
  ocamlPackages,
  fetchFromGitea,
  ocaml-crunch,
  seppo,
  lib,
}:

let
  mcdb = ocamlPackages.callPackage ./mcdb.nix { inherit seppo; };
in

ocamlPackages.buildDunePackage {
  pname = "seppo";
  version = "0-unstable-2025-06-03";

  src = fetchFromGitea {
    domain = "codeberg.org";
    owner = "seppo";
    repo = "seppo";
    rev = "33ae3e9f61d596fb91d3ab1a91fc26ae80981a93";
    hash = "sha256-tOIIfYBLcZqQzoPxAVkE8RGX0sugUmDGpxIhIZ5Wy+w=";
  };

  # Provide git sha to avoid git dependency
  env.GIT_SHA = seppo.src.rev;

  # Static build fails to find correct static libraries
  postPatch = ''
    sed -i 's/-static/""/' bin/gen_flags.sh
  '';

  nativeBuildInputs = [
    ocaml-crunch
  ];

  buildInputs = with ocamlPackages; [
    mcdb

    camlp-streams
    cohttp-lwt-unix
    crunch
    csexp
    decoders-ezjsonm
    lambdasoup
    lwt_ppx
    mirage-crypto-rng
    ocaml_sqlite3
    optint
    safepass
    timedesc
    tls-lwt
    tyre
    uucp
    uuidm
    uunf
    uutf
    x509
    xmlm
  ];

  meta = {
    homepage = "https://seppo.mro.name";
    description = "Personal Social Web";
    license = lib.licenses.gpl3Plus;
    maintainers = with lib.maintainers; [ infinidoge ];
    mainProgram = "seppo";
  };
}
