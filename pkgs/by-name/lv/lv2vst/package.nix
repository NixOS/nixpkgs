{
  lib,
  stdenv,
  fetchFromGitHub,
  nix-update-script,
}:
stdenv.mkDerivation {
  pname = "lv2vst";
  version = "0-unstable-2020-06-06";

  src = fetchFromGitHub {
    owner = "x42";
    repo = "lv2vst";
    rev = "30a669a021812da05258519cef9d4202f5ce26c3";
    fetchSubmodules = false;
    sha256 = "sha256-WFVscNivFrsADl7w5pSYx9g+UzK2XUBF7x0Iqg8WKiQ=";
  };

  makeFlags = [
    "PREFIX=$(out)"
    "VSTDIR=$(out)/lib/vst"
  ];

  enableParallelBuilding = true;

  passthru.updateScript = nix-update-script { extraArgs = [ "--version=branch" ]; };

  meta = {
    description = "Experimental LV2 to VST2.x wrapper";
    homepage = "https://github.com/x42/lv2vst";
    license = lib.licenses.gpl2Plus;
    maintainers = with lib.maintainers; [ bandithedoge ];
    platforms = [ "x86_64-linux" ];
  };
}
