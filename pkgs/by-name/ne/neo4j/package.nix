{
  stdenv,
  lib,
  fetchurl,
  nixosTests,
  makeWrapper,
<<<<<<< HEAD
  openjdk21,
=======
  openjdk17,
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
  which,
  gawk,
  bashNonInteractive,
}:

stdenv.mkDerivation rec {
  pname = "neo4j";
<<<<<<< HEAD
  version = "2025.10.1";

  src = fetchurl {
    url = "https://neo4j.com/artifact.php?name=neo4j-community-${version}-unix.tar.gz";
    hash = "sha256-aa3hZeM0ehMt6mZk/Of9qG85GnrvsasA8hzpQOppLwk=";
=======
  version = "5.26.1";

  src = fetchurl {
    url = "https://neo4j.com/artifact.php?name=neo4j-community-${version}-unix.tar.gz";
    hash = "sha256-RiCUpsUxUaMSz1a4ptNQ8rp99ffj0r4DPggt8RgSj7U=";
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
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
<<<<<<< HEAD
                openjdk21
=======
                openjdk17
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
                which
                gawk
              ]
            }" \
<<<<<<< HEAD
            --set JAVA_HOME "${openjdk21}"
=======
            --set JAVA_HOME "${openjdk17}"
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
    done

    patchShebangs $out/share/neo4j/bin/neo4j-admin

    # user will be asked to change password on first login
    # password must be at least 8 characters long
    $out/bin/neo4j-admin dbms set-initial-password neo4jadmin
  '';

  passthru.tests.nixos = nixosTests.neo4j;

<<<<<<< HEAD
  meta = {
    description = "Highly scalable, robust (fully ACID) native graph database";
    homepage = "https://neo4j.com/";
    license = lib.licenses.gpl3;
    maintainers = with lib.maintainers; [ offline ];
    platforms = lib.platforms.unix;
=======
  meta = with lib; {
    description = "Highly scalable, robust (fully ACID) native graph database";
    homepage = "https://neo4j.com/";
    license = licenses.gpl3;
    maintainers = with maintainers; [ offline ];
    platforms = platforms.unix;
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
  };
}
