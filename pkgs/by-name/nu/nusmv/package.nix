{
  stdenv,
  lib,
  fetchurl,
  autoPatchelfHook,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "NuSMV";
  version = "2.7.0";

  src = fetchurl {
    url = "https://nusmv.fbk.eu/distrib/${finalAttrs.version}/NuSMV-${finalAttrs.version}-linux64.tar.xz";
    sha256 = "019d1pa5aw58n11is1024hs8d520b3pp2iyix78vp04yv7wd42l8";
  };

  nativeBuildInputs = [ autoPatchelfHook ];

  installPhase = ''
    install -m755 -D bin/NuSMV $out/bin/NuSMV
    install -m755 -D bin/ltl2smv $out/bin/ltl2smv
    cp -r include $out/include
    cp -r lib $out/lib
  '';

  meta = {
    description = "New symbolic model checker for the analysis of synchronous finite-state and infinite-state systems";
    homepage = "https://nusmv.fbk.eu/";
    maintainers = with lib.maintainers; [ mgttlinger ];
    sourceProvenance = with lib.sourceTypes; [ binaryNativeCode ];
    platforms = [ "x86_64-linux" ];
    license = lib.licenses.lgpl21Plus;
  };
})
