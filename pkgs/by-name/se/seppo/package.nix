{
  ocamlPackages,
  fetchFromGitea,
  ocaml-crunch,
  seppo,
  lib,
  nix-update-script,
}:

let
  mcdb = ocamlPackages.callPackage ./mcdb.nix { inherit seppo; };
in

ocamlPackages.buildDunePackage {
  pname = "seppo";
  version = "0-unstable-2025-07-06";

  src = fetchFromGitea {
    domain = "codeberg.org";
    owner = "seppo";
    repo = "seppo";
    rev = "500f712be07076f70341f423e883ade576ee708c";
    hash = "sha256-wq2QPIJ3+/udzY8TvkSyMwqTL0RnKk0nKkQ/3sd/FKQ=";
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

  passthru.updateScript = nix-update-script {
    extraArgs = [ "--version=branch" ];
  };

  meta = {
    homepage = "https://seppo.mro.name";
    description = "Personal Social Web";
    license = lib.licenses.gpl3Plus;
    maintainers = with lib.maintainers; [ infinidoge ];
    teams = with lib.teams; [ ngi ];
    mainProgram = "seppo";
  };
}
