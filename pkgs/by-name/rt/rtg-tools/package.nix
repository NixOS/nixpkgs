{
  lib,
  stdenv,
  fetchFromGitHub,
  jdk,
  ant,
  git,
  coreutils,
  hostname,
  gawk,
  unzip,
}:

stdenv.mkDerivation rec {
  pname = "rtg-tools";
  version = "3.13";

  src = fetchFromGitHub {
    owner = "RealTimeGenomics";
    repo = "rtg-tools";
    rev = version;
    hash = "sha256-vPzKrgnX6BCQmn9aOVWWpFLC6SbPBHZhZ+oL1LCbvmo=";
  };

  nativeBuildInputs = [
    ant
    jdk
    git # Required by build.xml to manage the build revision
    unzip
  ];

  buildPhase = ''
    runHook preBuild
    ant rtg-tools.jar
    runHook postBuild
  '';

  installPhase = ''
    runHook preInstall
    mkdir -p $out/bin
    cp build/rtg-tools.jar $out/bin/RTG.jar
    cp installer/rtg $out/bin/
    runHook postInstall
  '';

  postPatch = ''
    # Use a location outside nix (must be writable)
    substituteInPlace installer/rtg \
      --replace-fail  '$THIS_DIR/rtg.cfg' '$HOME/.config/rtg-tools/rtg.cfg'  \
       --replace-fail 'RTG_JAVA="java"' 'RTG_JAVA="${lib.getExe jdk}"' \
      --replace-fail uname ${lib.getExe' coreutils "uname"} \
      --replace-fail awk ${lib.getExe gawk} \
      --replace-fail "hostname -s" "${lib.getExe hostname} -s"

    sed -i '/USER_JAVA_OPTS=$RTG_JAVA_OPTS/a mkdir -p $HOME/.config/rtg-tools'  installer/rtg
  '';

  checkPhase = ''
    ant runalltests
  '';

  meta = with lib; {
    homepage = "https://github.com/RealTimeGenomics/rtg-tools";
    description = "Useful utilities for dealing with VCF files and sequence data, especially vcfeval";
    license = licenses.bsd2;
    platforms = [ "x86_64-linux" ];
    maintainers = with maintainers; [ apraga ];
  };
}
