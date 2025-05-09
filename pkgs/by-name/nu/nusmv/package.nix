{
  stdenv,
  lib,
  fetchurl,
  autoPatchelfHook,
}:

stdenv.mkDerivation rec {
  pname = "NuSMV";
  version = "2.7.0";

  src =
    with stdenv;
    fetchurl (
      if isx86_64 && isLinux then
        {
          url = "https://nusmv.fbk.eu/distrib/${version}/NuSMV-${version}-linux64.tar.xz";
          sha256 = "019d1pa5aw58n11is1024hs8d520b3pp2iyix78vp04yv7wd42l8";
        }
      else if isx86_64 && isDarwin then
        {
          url = "https://nusmv.fbk.eu/distrib/${version}/NuSMV-${version}-macos-universal.tar.xz";
          sha256 = "098wllv4yx284qv9nsi8kd5pgh10cr1hig01a1p2rxgfmrki52wm";
        }
      else
        throw "only linux and mac x86_64 are currently supported"
    );

  nativeBuildInputs = lib.optionals stdenv.isLinux [ autoPatchelfHook ];

  installPhase = ''
    install -m755 -D bin/NuSMV $out/bin/NuSMV
    install -m755 -D bin/ltl2smv $out/bin/ltl2smv
    cp -r include $out/include
    cp -r lib $out/lib
  '';

  meta = with lib; {
    description = "New symbolic model checker for the analysis of synchronous finite-state and infinite-state systems";
    homepage = "https://nusmv.fbk.eu/";
    maintainers = with maintainers; [ mgttlinger ];
    sourceProvenance = with sourceTypes; [ binaryNativeCode ];
    platforms = platforms.linux ++ platforms.darwin;
  };
}
