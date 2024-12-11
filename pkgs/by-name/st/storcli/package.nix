{
  lib,
  stdenvNoCC,
  fetchzip,
  rpmextract,
  testers,
}:

stdenvNoCC.mkDerivation (finalAttrs: {
  pname = "storcli";
  version = "7.3103.00";
  phase = "32";

  src = fetchzip {
    url = "https://docs.broadcom.com/docs-and-downloads/host-bus-adapters/host-bus-adapters-common-files/sas_sata_nvme_12g_p${finalAttrs.phase}/STORCLI_SAS3.5_P${finalAttrs.phase}.zip";
    hash = "sha256-bOlIChZi2eWpc5QA+wXBQA4s+o/MVLVWsligjDpUXEU=";
  };

  nativeBuildInputs = [ rpmextract ];

  unpackPhase =
    let
      inherit (stdenvNoCC.hostPlatform) system;
      platforms = {
        x86_64-linux = "Linux";
        aarch64-linux = "ARM/Linux";
      };
      platform = platforms.${system} or (throw "unsupported system: ${system}");
    in
    ''
      rpmextract $src/univ_viva_cli_rel/Unified_storcli_all_os/${platform}/storcli-00${finalAttrs.version}00.0000-1.*.rpm
    '';

  dontPatch = true;
  dontConfigure = true;
  dontBuild = true;

  installPhase = ''
    install -D ./opt/MegaRAID/storcli/storcli64 $out/bin/storcli64
    ln -s storcli64 $out/bin/storcli
  '';

  # Not needed because the binary is statically linked
  dontFixup = true;

  passthru.tests = testers.testVersion {
    package = finalAttrs.finalPackage;
    command = "${finalAttrs.meta.mainProgram} -v";
    version = "00${finalAttrs.version}00.0000";
  };

  meta = with lib; {
    # Unfortunately there is no better page for this.
    # Filter for downloads, set 100 items per page. Sort by newest does not work.
    # Then search manually for the latest version.
    homepage = "https://www.broadcom.com/support/download-search?pg=&pf=Host+Bus+Adapters&pn=&pa=&po=&dk=storcli&pl=&l=false";
    description = "Storage Command Line Tool";
    sourceProvenance = with sourceTypes; [ binaryNativeCode ];
    license = licenses.unfree;
    maintainers = with maintainers; [ panicgh ];
    mainProgram = "storcli";
    platforms = [
      "x86_64-linux"
      "aarch64-linux"
    ];
  };
})
