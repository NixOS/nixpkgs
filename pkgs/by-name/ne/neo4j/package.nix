{
  stdenv,
  lib,
  fetchurl,
  nixosTests,
  makeWrapper,
  openjdk21,
  which,
  gawk,
  bashNonInteractive,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "neo4j";
  version = "2026.01.3";

  src = fetchurl {
    url = "https://neo4j.com/artifact.php?name=neo4j-community-${finalAttrs.version}-unix.tar.gz";
    hash = "sha256-/ZN2GGA0qE7so4SXGy6ePoD45BFmUphD9JxI45CkhpQ=";
  };

  nativeBuildInputs = [ makeWrapper ];
  buildInputs = [ bashNonInteractive ];
  strictDeps = true;

  installPhase = ''
    mkdir -p "$out/share/neo4j"
    cp -R * "$out/share/neo4j"

    mkdir -p "$out/bin"
    for NEO4J_SCRIPT in neo4j neo4j-admin cypher-shell
    do
        chmod +x "$out/share/neo4j/bin/$NEO4J_SCRIPT"
        makeWrapper "$out/share/neo4j/bin/$NEO4J_SCRIPT" \
            "$out/bin/$NEO4J_SCRIPT" \
            --prefix PATH : "${
              lib.makeBinPath [
                openjdk21
                which
                gawk
              ]
            }" \
            --set JAVA_HOME "${openjdk21}"
    done

    patchShebangs $out/share/neo4j/bin/neo4j-admin

    # user will be asked to change password on first login
    # password must be at least 8 characters long
    $out/bin/neo4j-admin dbms set-initial-password neo4jadmin
  '';

  passthru.tests.nixos = nixosTests.neo4j;

  meta = {
    description = "Highly scalable, robust (fully ACID) native graph database";
    homepage = "https://neo4j.com/";
    license = lib.licenses.gpl3;
    maintainers = [ ];
    platforms = lib.platforms.unix;
  };
})
