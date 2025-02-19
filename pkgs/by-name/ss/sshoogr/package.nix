{
  lib,
  stdenv,
  fetchzip,
  jdk,
  makeWrapper,
}:

stdenv.mkDerivation rec {
  pname = "sshoogr";
  version = "0.9.26";

  src = fetchzip {
    url = "mirror://maven/com/aestasit/infrastructure/${pname}/${pname}/${version}/${pname}-${version}.zip";
    sha256 = "134qlx90y82g1rfxhyn12z9r2imm1l3fz09hrrn3pgcdcq5jz2s1";
  };

  nativeBuildInputs = [ makeWrapper ];

  installPhase = ''
    rm bin/sshoogr.bat
    cp -r . $out
    wrapProgram $out/bin/sshoogr \
      --prefix JAVA_HOME : ${jdk}
  '';

  meta = with lib; {
    description = ''
      A Groovy-based DSL for working with remote SSH servers
    '';
    mainProgram = "sshoogr";
    longDescription = ''
      The sshoogr (pronounced [ʃʊgə]) is a Groovy-based DSL library for working
      with remote servers through SSH. The DSL allows: connecting, executing
      remote commands, copying files and directories, creating tunnels in a
      simple and concise way.
    '';
    homepage = "https://github.com/aestasit/sshoogr";
    license = licenses.asl20;
    platforms = platforms.all;
    maintainers = with maintainers; [ moaxcp ];
  };
}
