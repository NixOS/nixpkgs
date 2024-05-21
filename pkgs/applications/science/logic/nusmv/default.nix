{ stdenv
, lib
, fetchurl
, autoPatchelfHook
}:

stdenv.mkDerivation rec {
  pname = "NuSMV";
  version = "2.6.0";

  src = with stdenv; fetchurl (
    if isx86_64 && isLinux then {
      url = "https://nusmv.fbk.eu/distrib/NuSMV-${version}-linux64.tar.gz";
      sha256 = "1370x2vwjndv9ham5q399nn84hvhm1gj1k7pq576qmh4pi12xc8i";
    } else if isx86_32 && isLinux then {
      url = "https://nusmv.fbk.eu/distrib/NuSMV-${version}-linux32.tar.gz";
      sha256 = "1qf41czwbqxlrmv0rv2daxgz2hljza5xks85sx3dhwpjy2iav9jb";
    } else throw "only linux x86_64 and x86_32 are currently supported") ;


  nativeBuildInputs = [ autoPatchelfHook ];

  installPhase = ''
    install -m755 -D bin/NuSMV $out/bin/NuSMV
    install -m755 -D bin/ltl2smv $out/bin/ltl2smv
    cp -r include $out/include
    cp -r share $out/share
  '';

  meta = with lib; {
    description = "A new symbolic model checker for the analysis of synchronous finite-state and infinite-state systems";
    homepage = "https://nuxmv.fbk.eu/pmwiki.php";
    maintainers = with maintainers; [ mgttlinger ];
    sourceProvenance = with sourceTypes; [ binaryNativeCode ];
    platforms = platforms.linux;
  };
}
