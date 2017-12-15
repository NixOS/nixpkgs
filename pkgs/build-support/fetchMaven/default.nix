{ stdenv, maven }: { src, sha256 }:

stdenv.mkDerivation {
  name = "maven-repo";

  outputHashAlgo = "sha256";
  outputHash = sha256;
  outputHashMode = "recursive";

  nativeBuildInputs = [ maven ];

  buildCommand = ''
    ln -s ${src}/* .

    # Unfortunately, dependency:go-offline phase can't infer dependencies injected
    # at build time by some Maven plugins, which makes it impossible to fetch all
    # dependencies without the first build...
    mvn -Dmaven.repo.local=$out package

    find $out \( -name _remote.repositories -or -name \*.lastUpdated \) -delete
  '';
}
