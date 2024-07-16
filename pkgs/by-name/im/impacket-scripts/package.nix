{ lib
, stdenvNoCC
, fetchFromGitLab
, python3Packages
, impacket ? python3Packages.impacket
}:

stdenvNoCC.mkDerivation (finalAttrs: {
  pname = "impacket-scripts";
  version = "1.8";

  src = fetchFromGitLab {
    group = "kalilinux";
    owner = "packages";
    repo = "impacket-scripts";
    rev = "kali/${finalAttrs.version}";
    hash = "sha256-FBULA2hhdGEICVTWeY0zzc8+gweZpaDWirYajv943vQ=";
  };

  installPhase = ''
    runHook preInstall

    mkdir -p $out/bin
    while read p; do
      binName=$(echo "$p" | cut -d/ -f6)
      scriptName="$(echo "$binName" | cut -d- -f2-).py"
      script="${impacket}/bin/$scriptName"

      if [ ! -f "$script" ]; then
        echo "error: $scriptName does not exist at $script"
        exit 1
      fi
      ln -s "$script" "$out/bin/$binName"
    done <debian/links

    runHook postInstall
  '';

  meta = {
    description = "This package contains links to useful impacket scripts";
    homepage = "https://www.kali.org/tools/impacket-scripts/";
    license = lib.licenses.gpl2Plus;
    maintainers = with lib.maintainers; [ emilytrau ];
    inherit (impacket.meta) platforms;
  };
})
