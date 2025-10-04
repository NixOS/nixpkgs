{
  lib,
  stdenvNoCC,
  fetchurl,
  buildFHSEnv,
}:

let
  pname = "mpm";
  version = "2024.4";

  mpm-bin = stdenvNoCC.mkDerivation {
    inherit pname version;

    src = fetchurl {
      # https://www.mathworks.com/mpm/glnxa64/mpm redirects to here
      url = "https://ssd.mathworks.com/supportfiles/downloads/mpm/${version}/glnxa64/mpm";
      hash = "sha256-KEdIOGpvFJX7xfZ46lkXZAWFOQe13GtB4CmMkf+yZrY=";
      executable = true;
    };
    dontUnpack = true;

    installPhase = ''
      runHook preInstall
      mkdir -p $out/bin
      cp $src $out/bin/mpm
      runHook postInstall
    '';
  };
in
buildFHSEnv {
  inherit pname version;
  runScript = "mpm";

  targetPkgs =
    pkgs: with pkgs; [
      mpm-bin
      pam
      zlib
    ];

  meta = {
    mainProgram = "mpm";
    description = "MATLAB Package Manager";
    homepage = "https://www.mathworks.com/help/install/ug/get-mpm-os-command-line.html";
    platforms = [ "x86_64-linux" ];
    sourceProvenance = [ lib.sourceTypes.binaryNativeCode ];
    license = lib.licenses.unfree;
    maintainers = with lib.maintainers; [ james-atkins ];
  };
}
