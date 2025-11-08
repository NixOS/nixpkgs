{
  lib,
  fetchpatch,
  fetchFromGitHub,
  ocamlPackages,
  opam,
  makeBinaryWrapper,
  writableTmpDirAsHomeHook,
  unstableGitUpdater,
  testers,
  cerberus,
}:
ocamlPackages.buildDunePackage rec {
  pname = "cerberus";
  version = "0-unstable-2025-08-18";

  src = fetchFromGitHub {
    owner = "rems-project";
    repo = "cerberus";
    rev = "9eb2ce27adc4a45c69da347c660d9b5477d764a8";
    hash = "sha256-++fCZvk4ee166eciipTQ8GId6DWrG6aonAzHpK/10f0=";
  };

  patches = [
    # https://github.com/rems-project/cerberus/pull/980
    (fetchpatch {
      name = "fix-runtime-lookup";
      url = "https://github.com/rems-project/cerberus/commit/262c13331d4809dd3742069dbcd1deedee8227f2.patch";
      hash = "sha256-yPhzswMDkpjvjYyobnqoF3900l4THe0kaGme1eZXLQc=";
    })
  ];

  # Cerberus has not had a true release yet, and it parses out a git rev
  # for version info. We just patch the "didn't find git revs" to
  # our version since git is impure
  postPatch = ''
    substituteInPlace tools/gen_version.ml \
      --replace-fail '"unknown"' '"${version}"'
  '';

  minimalOCamlVersion = "4.12";

  depsBuildBuild = [
    ocamlPackages.menhir
    ocamlPackages.lem
  ];

  nativeBuildInputs = [
    writableTmpDirAsHomeHook
    makeBinaryWrapper
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

  # Need to set this or it complains. I don't
  # think the actual value matters much
  env.OPAM_SWITCH_PREFIX = placeholder "out";

  # Use the make file as it does some codegen
  buildPhase = ''
    runHook preBuild

    make DUNEFLAGS="--profile=release" Q= -j$NIX_BUILD_CORES cerberus

    runHook postBuild
  '';

  # Must install both the stdlib
  # and the executable itself
  installPhase = ''
    runHook preInstall

    dune install --prefix $out --libdir $OCAMLFIND_DESTDIR cerberus-lib --docdir $out/share/doc --mandir $out/share/man
    dune install --prefix $out --libdir $OCAMLFIND_DESTDIR cerberus --docdir $out/share/doc --mandir $out/share/man

    wrapProgram "$out/bin/cerberus" \
      --set CERB_INSTALL_PREFIX "$out/lib/ocaml/${ocamlPackages.ocaml.version}/site-lib/"

    runHook postInstall
  '';

  doInstallCheck = true;
  installCheckPhase = ''
    runHook preInstallCheck

    PATH="$out/bin":$PATH

    patchShebangs --build tests

    tests/run-ci.sh

    runHook postInstallCheck
  '';

  passthru = {
    updateScript = unstableGitUpdater { branch = "master"; };

    # Ensure it still runs after outside the container
    tests.version = testers.testVersion {
      package = cerberus;
    };
  };

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
