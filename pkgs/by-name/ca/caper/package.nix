{
  stdenv,
  lib,
  ocaml,
  ocamlPackages,
  gnum4,
  fetchFromGitLab,
}:
stdenv.mkDerivation rec {
  pname = "caper";
  version = "0.9";

  src = fetchFromGitLab {
    owner = "niksu";
    repo = "caper";
    rev = "v${version}";
    hash = "sha256-TSryjz0NrGdkc+6vmfBqsuVpV3N9FvteTFsVqpUcm0w=";
  };

  nativeBuildInputs = [
    ocaml
    ocamlPackages.ocamlbuild
    ocamlPackages.findlib
    ocamlPackages.menhir
    gnum4
  ];

  buildInputs = [
    ocamlPackages.angstrom
  ];

  strictDeps = true;

  buildPhase = ''
    runHook preBuild
    CAPER_WITH_ENGLISH=yes bash build.sh caper.native
    runHook postBuild
  '';

  installPhase = ''
    runHook preInstall
    mkdir -p $out/bin
    cp caper.native $out/bin/caper
    runHook postInstall
  '';

  meta = {
    description = "Tool for understanding and processing pcap (packet capture) expressions";
    longDescription = ''
      Caper is a tool for understanding and processing "pcap expressions" (also known as *tcpdump filters*) which are used for network packet analysis.
      Caper can be used for:
      * Expanding out pcap expressions "in full" to understand their implicit features.
      * Reasoning about whether two expressions accept the same set of packets, or how their accepted packets differ.
      * Converting pcap expressions into BPF programs.
      * Converting between pcap expressions and English.

      More info can be found in the Caper paper (https://www.nik.network/caper/pcap_semantics.pdf).
    '';
    homepage = "https://gitlab.com/niksu/caper";
    license = lib.licenses.gpl3Plus;
    maintainers = with lib.maintainers; [ willow_ch ];
    mainProgram = "caper";
  };
}
