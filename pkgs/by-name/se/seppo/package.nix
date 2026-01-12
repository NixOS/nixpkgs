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
  version = "0-unstable-2025-08-07";

  src = fetchFromGitea {
    domain = "codeberg.org";
    owner = "seppo";
    repo = "seppo";
    rev = "d927311cae64883fe2b88f5a1c7e17c8cc525bad";
    hash = "sha256-Lb2w0mRNNamCltAwdxOyAYh02wkN7yKJGBzqBIPKE8k=";
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
