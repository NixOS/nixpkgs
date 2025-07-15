{
  lib,
  stdenv,
  fetchFromGitHub,
  installShellFiles,
  versionCheckHook,
  zlib,
  nix-update-script,
}:

stdenv.mkDerivation rec {
  pname = "minimap2";
  version = "2.30";

  src = fetchFromGitHub {
    repo = "minimap2";
    owner = "lh3";
    rev = "v${version}";
    sha256 = "sha256-TnJ/h04QdTdL56yyh+3Po19UAzrAkictu5Q6OiCQ2DY=";
  };

  buildInputs = [ zlib ];

  nativeBuildInputs = [ installShellFiles ];

  makeFlags =
    lib.optionals stdenv.hostPlatform.isAarch [ "arm_neon=1" ]
    ++ lib.optionals stdenv.hostPlatform.isAarch64 [ "aarch64=1" ];

  installPhase = ''
    runHook preInstall
    install -m755 -Dt $out/bin minimap2
    installManPage minimap2.1
    runHook postInstall
  '';

  nativeInstallCheckInputs = [ versionCheckHook ];
  versionCheckProgramArg = "--version";
  doInstallCheck = true;

  passthru.updateScript = nix-update-script { };

  meta = with lib; {
    description = "Versatile pairwise aligner for genomic and spliced nucleotide sequences";
    longDescription = ''
      Minimap2 is a versatile sequence alignment program that aligns
      DNA or mRNA sequences against a large reference database. It is
      particularly efficient for long reads and can handle various
      sequencing technologies including PacBio and Oxford Nanopore.
    '';
    mainProgram = "minimap2";
    homepage = "https://lh3.github.io/minimap2";
    license = licenses.mit;
    platforms = platforms.unix;
    maintainers = [ maintainers.arcadio ];
  };
}
