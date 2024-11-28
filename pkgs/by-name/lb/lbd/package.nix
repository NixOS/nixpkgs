{ lib
, stdenvNoCC
, fetchFromGitHub
, makeWrapper
, bash
, coreutils
, diffutils
, gawk
, gnugrep
, gnused
, host
, netcat-openbsd
}:

stdenvNoCC.mkDerivation {
  pname = "lbd";
  version = "0-unstable-2024-02-17";

  src = fetchFromGitHub {
    owner = "D3vil0p3r";
    repo = "lbd";
    rev = "73baaaecddcd834d43d79f50f0808b779c9a97c3";
    hash = "sha256-NHY3NoPigsmfRjOx9Lt3/fGsyeq1/bzKHIXMDBJiI6c=";
  };

  nativeBuildInputs = [
    makeWrapper
  ];

  installPhase = ''
    runHook preInstall
    mkdir -p $out/{bin,share/lbd}
    cp lbd $out/share/lbd/
    makeWrapper ${lib.getExe bash} $out/bin/lbd \
      --prefix PATH : "${lib.makeBinPath [ coreutils diffutils gawk gnugrep gnused host netcat-openbsd ]}" \
      --add-flags "$out/share/lbd/lbd"
    runHook postInstall
  '';

  meta = with lib; {
    description = "Detect if a domain uses DNS and/or HTTP Load-Balancing";
    mainProgram = "lbd";
    homepage = "https://github.com/D3vil0p3r/lbd";
    maintainers = with maintainers; [ d3vil0p3r ];
    platforms = platforms.unix;
    license = licenses.gpl2Plus;
  };
}
