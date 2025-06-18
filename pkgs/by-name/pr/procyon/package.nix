{
  lib,
  stdenv,
  fetchurl,
  runtimeShell,
  jre_headless,
}:

stdenv.mkDerivation rec {
  pname = "procyon";
  version = "0.6.0";

  src = fetchurl {
    url = "https://github.com/mstrobel/procyon/releases/download/v${version}/procyon-decompiler-${version}.jar";
    sha256 = "sha256-gh2pYBL8aSRPoeopjJBFXuTgIUNLx5bTuVRqskYBt3k=";
  };

  dontUnpack = true;

  installPhase = ''
    mkdir -p $out/bin $out/share/procyon
    cp $src $out/share/procyon/procyon-decompiler.jar

    cat << EOF > $out/bin/procyon
    #!${runtimeShell}
    exec ${jre_headless}/bin/java -jar $out/share/procyon/procyon-decompiler.jar "\$@"
    EOF
    chmod +x $out/bin/procyon
  '';

  meta = with lib; {
    description = "Procyon is a suite of Java metaprogramming tools including a Java decompiler";
    sourceProvenance = with sourceTypes; [ binaryBytecode ];
    homepage = "https://github.com/mstrobel/procyon/";
    license = licenses.asl20;
    maintainers = [ ];
    mainProgram = "procyon";
  };
}
