{
  stdenv,
  lib,
  fetchurl,
  dpkg,
  makeWrapper,
  jre_headless,
  coreutils,
  findutils,
  gnused,
  jq,
  systemd,
  sudo,
}:
stdenv.mkDerivation (finalAttrs: {
  pname = "microsoft-identity-diagnostics";
  version = "3.0.2-resolute";
  ubuntuVersion = "26.04";

  src = fetchurl {
    url = "https://packages.microsoft.com/ubuntu/${finalAttrs.ubuntuVersion}/prod/pool/main/m/microsoft-identity-diagnostics/microsoft-identity-diagnostics_${finalAttrs.version}_amd64.deb";
    hash = "sha256-t7IAiQ9aNAxoDzUPjzn+28ol4XPocf172qJ9+ytJjX4=";
  };

  nativeBuildInputs = [
    dpkg
    makeWrapper
  ];

  installPhase = ''
    runHook preInstall

    mkdir -p $out/bin $out/share
    cp -a opt/microsoft/microsoft-identity-diagnostics $out/share/

    makeWrapper \
      $out/share/microsoft-identity-diagnostics/bin/microsoft-identity-diagnostics \
      $out/bin/microsoft-identity-diagnostics-uploader \
      --prefix PATH : ${
        lib.makeBinPath [
          coreutils
          findutils
          gnused
          jre_headless
        ]
      }

    makeWrapper \
      $out/share/microsoft-identity-diagnostics/scripts/collect_logs \
      $out/bin/collect-microsoft-identity-diagnostics \
      --prefix PATH : "$out/bin:${
        lib.makeBinPath [
          coreutils
          jq
          sudo
          systemd
        ]
      }"

    runHook postInstall
  '';

  passthru.updateScript = ./update.sh;

  meta = {
    description = "Microsoft Identity diagnostic log collection and upload tool";
    homepage = "https://www.microsoft.com/";
    license = lib.licenses.unfree;
    mainProgram = "collect-microsoft-identity-diagnostics";
    maintainers = with lib.maintainers; [ codgician ];
    platforms = [ "x86_64-linux" ];
    sourceProvenance = with lib.sourceTypes; [ binaryBytecode ];
  };
})
