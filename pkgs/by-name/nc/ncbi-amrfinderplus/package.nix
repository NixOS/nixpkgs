{
  blast,
  curl,
  fetchFromGitHub,
  hmmer,
  lib,
  makeWrapper,
  stdenv,
  versionCheckHook,
}:

stdenv.mkDerivation rec {
  pname = "ncbi-amrfinderplus";
  version = "4.0.23";

  src = fetchFromGitHub {
    owner = "ncbi";
    repo = "amr";
    tag = "amrfinder_v${version}";
    hash = "sha256-Rnw83v19dc9Hi/S6MqdYqz/kbTUWrp5i8gpaaPsDK1A=";
    fetchSubmodules = true;
  };

  buildInputs = [ curl ];

  nativeBuildInputs = [ makeWrapper ];
  nativeInstallCheckInputs = [ versionCheckHook ];
  doInstallCheck = true;
  versionCheckProgramArg = "--version";

  installPhase = ''
    runHook preInstall

    make install PREFIX=$out

    runHook postInstall
  '';

  postPatch = ''
    substituteInPlace stx/test_stxtyper.sh \
      --replace-fail "curl " "${curl}/bin/curl "
  '';

  postFixup = ''
    for bin in $out/bin/*; do
      case "$(basename "$bin")" in
        stx/test_stxtyper.sh|stx.prot|stx)
          # Don't wrap these files/dir
          ;;
        *)
          wrapProgram "$bin" --prefix PATH : ${
            lib.makeBinPath [
              blast
              hmmer
            ]
          }
          ;;
      esac
    done
  '';

  meta = {
    description = "Identify AMR genes and point mutations, and virulence and stress resistance genes in assembled bacterial nucleotide and protein sequence";
    longDescription = ''
      This NCBI tool can be used for identifying acquired antimicrobial resistance genes in bacterial protein and/or assembled nucleotide sequences, as well as known resistance-associated point mutations for several taxa.

      Note: The AMRFinderPlus database is not included in this package.
      To obtain and index the database, users should run `amrfinder_update -d <dir>`
      after installation to download it to a directory of their choice.
    '';
    homepage = "https://www.ncbi.nlm.nih.gov/pathogens/antimicrobial-resistance/AMRFinder/";
    changelog = "https://github.com/ncbi/amr/releases/tag/amrfinder_v${version}/";
    license = [ lib.licenses.ncbiPd ];
    maintainers = [ lib.maintainers.dflores ];
    mainProgram = "amrfinder";
    platforms = lib.platforms.unix;
  };
}
