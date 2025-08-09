{
  lib,
  fetchFromGitHub,
  writableTmpDirAsHomeHook,
  unstableGitUpdater,
  ocamlPackages,
  opam,
}:
ocamlPackages.buildDunePackage {
  pname = "cerberus";
  version = "0-unstable-2025-07-25";

  src = fetchFromGitHub {
    owner = "rems-project";
    repo = "cerberus";
    rev = "9f8f2d375366e8c6c3c60dcf2da757344d877b14";
    hash = "sha256-wwc2XXQ3AdXBhBX7FPhpm56w3g9rrC8tESelcXSwjPE=";
  };

  minimalOCamlVersion = "4.12";

  strictDeps = true;

  nativeBuildInputs = [
    opam
    writableTmpDirAsHomeHook
    ocamlPackages.lem
    ocamlPackages.menhir
  ];

  buildInputs = with ocamlPackages; [
    sha
    pprint
    cmdliner
    yojson
    lem
    result
    ppx_deriving
    zarith
    sexplib
    menhirLib
    janeStreet.ppx_sexp_conv
  ];

  env.OPAM_SWITCH_PREFIX = placeholder "out";
  buildPhase = ''
    runHook preBuild

    make Q= cerberus

    runHook postBuild
  '';

  doInstallCheck = true;
  installCheckPhase = ''
    runHook preInstallCheck

    PATH="$out/bin":$PATH

    patchShebangs --build tests

    tests/run-ci.sh

    runHook postInstallCheck
  '';

  passthru.updateScript = unstableGitUpdater { branch = "master"; };

  meta = {
    homepage = "https://www.cl.cam.ac.uk/~pes20/cerberus/";
    license = with lib.licenses; [
      # Most of Cerberus
      bsd2
      # https://github.com/rems-project/cerberus/blob/master/THIRD_PARTY_FILES.md
      # Files from Linux kernel
      gpl2Only
      # Files from cppmem
      bsd3
      # Files from musl
      mit
      # Files from BSD
      bsdOriginal
      # Slightly modified vendored SibylFS
      isc
    ];
    mainProgram = "cerberus";
    maintainers = with lib.maintainers; [
      RossSmyth
    ];
    platforms = lib.platforms.unix;
  };
}
