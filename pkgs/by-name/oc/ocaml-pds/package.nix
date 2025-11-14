{
  lib,
  stdenv,
  fetchhg,
  ocaml,
  ocaml-crunch,
  ocamlPackages,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "ocaml-pds";
  version = "6.55";

  src = fetchhg {
    url = "https://hg.sr.ht/~mmatalka/pds";
    rev = finalAttrs.version;
    sha256 = "sha256-a6sMFzAwqLsLOq75JTyFxZiXuQvmOZG0bPzPehzLcws=";
  };

  strictDeps = true;

  nativeBuildInputs = [
    ocaml
    ocaml-crunch
    ocamlPackages.findlib
  ];

  buildInputs = with ocamlPackages; [
    cmdliner
    containers
    crunch
    fmt
    logs
    ppx_deriving
    process
    sedlex
    toml
    ocaml_sqlite3
  ];

  buildFlags = [ "all" ];

  preInstall = ''
    mkdir -p $out/bin
  '';

  makeFlags = [
    "PREFIX=${placeholder "out"}"
  ];

  doInstallCheck = true;
  installCheckPhase = ''
    runHook preInstallCheck
    $out/bin/pds --help
    runHook postInstallCheck
  '';

  meta = with lib; {
    description = "A tool to build Makefiles for OCaml projects";
    longDescription = ''
      pds is a build system for Ocaml that is meant to make it easy to build a project that follows a particular layout by generating a makefile for the project. The input to pds is a config file, pds.conf, and a directory structure, which is always the current working directory, and the output is the build description.
    '';
    homepage = "https://hg.sr.ht/~mmatalka/pds";
    changelog = "https://hg.sr.ht/~mmatalka/pds#changelog";
    license = licenses.bsd3;
    maintainers = with maintainers; [ mtrsk ];
    platforms = ocaml.meta.platforms;
  };
})
