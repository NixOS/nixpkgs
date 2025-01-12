{
  lib,
  stdenvNoCC,
  fetchzip,
  rpmextract,
}:

stdenvNoCC.mkDerivation rec {
  pname = "perccli";

  # On a new release, update version, URL, hash, and meta.homepage
  version = "7.2313.00";

  src = fetchzip {
    # On pkg update: manually adjust the version in the URL because of the different format.
    url = "https://dl.dell.com/FOLDER09770976M/1/PERCCLI_7.2313.0_A14_Linux.tar.gz";
    hash = "sha256-IhclHVkdihRx5CzyO2dlOEhCon+0/HB3Fkue7MWsWnw=";

    # Dell seems to block "uncommon" user-agents, such as Nixpkgs's custom one.
    # 403 otherwise
    curlOptsList = [
      "--user-agent"
      "Mozilla/5.0"
    ];
  };

  nativeBuildInputs = [ rpmextract ];

  unpackPhase = ''
    rpmextract $src/perccli-00${version}00.0000-1.noarch.rpm
  '';

  dontPatch = true;
  dontConfigure = true;
  dontBuild = true;

  installPhase =
    let
      inherit (stdenvNoCC.hostPlatform) system;
      platforms = {
        x86_64-linux = ''
          install -D ./opt/MegaRAID/perccli/perccli64 $out/bin/perccli64
          ln -s perccli64 $out/bin/perccli
        '';
      };
    in
    platforms.${system} or (throw "unsupported system: ${system}");

  # Not needed because the binary is statically linked
  dontFixup = true;

  meta = with lib; {
    description = "Perccli Support for PERC RAID controllers";

    # Must be updated with every release
    homepage = "https://www.dell.com/support/home/en-us/drivers/driversdetails?driverid=tdghn";

    sourceProvenance = with sourceTypes; [ binaryNativeCode ];
    license = licenses.unfree;
    maintainers = with maintainers; [ panicgh ];
    platforms = [ "x86_64-linux" ];
  };
}
