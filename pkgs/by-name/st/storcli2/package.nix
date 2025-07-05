{
  lib,
  stdenvNoCC,
  fetchzip,
  rpmextract,
  testers,
}:
stdenvNoCC.mkDerivation (
  finalAttrs:
  let
    majVer = "8";
    minVer = "11";
    relPhs = "14";
    verCode = "00" + majVer + ".00" + minVer + ".0000.00" + relPhs;
  in
  {
    pname = "storcli";
    version = majVer + "." + minVer;

    src = fetchzip {
      url = "https://docs.broadcom.com/docs-and-downloads/host-bus-adapters/host-bus-adapters-common-files/sas_sata_nvme_24g_p${finalAttrs.version}/StorCLI_Avenger_${finalAttrs.version}-${verCode}.zip";
      hash = "sha256-vztV+Jp+p6nU4q7q8QQIkuL30QsoGj2tyIZp87luhH8=";
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
        rpmextract $src/Avenger_StorCLI/${platform}/storcli2-${verCode}-1.*.rpm
      '';

    dontPatch = true;
    dontConfigure = true;
    dontBuild = true;

    installPhase = ''
      install -D ./opt/MegaRAID/storcli2/storcli2 $out/bin/storcli2
    '';

    # Not needed because the binary is statically linked
    dontFixup = false;

    passthru.tests = testers.testVersion {
      package = finalAttrs.finalPackage;
      command = "${finalAttrs.meta.mainProgram} v";
      version = verCode;
    };

    meta = with lib; {
      # Unfortunately there is no better page for this.
      # Filter for downloads, set 100 items per page. Sort by newest does not work.
      # Then search manually for the latest version.
      homepage = "https://www.broadcom.com/support/download-search?pg=&pf=Host+Bus+Adapters&pn=&pa=&po=&dk=storcli2&pl=&l=false";
      description = "Storage Command Line Tool";
      sourceProvenance = with sourceTypes; [ binaryNativeCode ];
      license = licenses.unfree;
      maintainers = with maintainers; [ edwtjo ];
      mainProgram = "storcli2";
      platforms = [
        "x86_64-linux"
        "aarch64-linux"
      ];
    };
  }
)
