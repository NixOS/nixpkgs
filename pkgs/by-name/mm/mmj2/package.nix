{
  lib,
  maven,
  fetchFromGitHub,
  jre,
  makeWrapper,
}:

let
  lastVersion = "2.5.2";

in
maven.buildMavenPackage {
  pname = "mmj2";

  # The latest stable version is from 2017 and doesn't include the mmj2jar/mmj2
  # wrapper script, so use the unstable one for now
  version = "${lastVersion}-unstable-2023-06-27";

  src = fetchFromGitHub {
    owner = "digama0";
    repo = "mmj2";
    fetchSubmodules = true;
    rev = "1cd95c1fe4435899c8575644fccb412dd77d79e4";
    hash = "sha256-WYBrLY04+bJGzjRMs8LgHnI6lMRhQKyz15DIoLeiE2s=";
  };

  mvnHash = "sha256-fu/q6CTvSllrfgnKNX6aIuPO65H/q0IPCHFuWmOFOvM=";

  nativeBuildInputs = [ makeWrapper ];

  installPhase = ''
    runHook preInstall

    local jar=$out/share/$pname/$pname.jar
    local bin=$out/bin/$pname
    install -Dm644 target/$pname-${lastVersion}-SNAPSHOT-jar-with-dependencies.jar $jar
    install -Dm744 mmj2jar/$pname $bin
    wrapProgram $bin \
      --set MMJ2_JAR $jar \
      --set JAVA ${jre}/bin/java

    runHook postInstall
  '';

  meta = with lib; {
    description = "GUI Proof Assistant for the Metamath project";
    longDescription = ''
      mmj2 is a proof assistant for the Metamath language. Metamath is a
      language that lets you express mathematical axioms and theorems. The proof
      assistant includes a GUI for creating proofs, proof verification tools,
      and grammatical/syntax analysis.
    '';
    homepage = "https://github.com/digama0/mmj2";
    license = licenses.gpl2Plus;
    maintainers = with maintainers; [ io12 ];
    platforms = platforms.linux;
    mainProgram = "mmj2";
  };
}
