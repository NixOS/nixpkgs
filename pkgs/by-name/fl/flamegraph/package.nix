{
  lib,
  stdenv,
  fetchFromGitHub,
  perl,
}:

stdenv.mkDerivation rec {
  pname = "FlameGraph";
  version = "2023-11-06";

  src = fetchFromGitHub {
    owner = "brendangregg";
    repo = pname;
    rev = "a96184c6939f8c6281fcd7285b54fba80555ac74";
    sha256 = "sha256-hvp1HxmgNbe85kxe0NyolFUd+kPPBDYAt+g2K8pE1Ak=";
  };

  buildInputs = [ perl ];

  installPhase = ''
    runHook preInstall

    mkdir -p $out/bin
    for x in $src/*.pl $src/*.awk $src/dev/*.pl $src/dev/*.d; do
      cp $x $out/bin
    done

    runHook postInstall
  '';

  doCheck = true;

  checkPhase = ''
    patchShebangs ./test.sh
    ./test.sh
  '';

  meta = with lib; {
    license = with licenses; [
      asl20
      cddl
      gpl2Plus
    ];
    homepage = "http://www.brendangregg.com/flamegraphs.html";
    description = "Visualization for profiled code";
    mainProgram = "flamegraph.pl";
    platforms = platforms.unix;
  };
}
