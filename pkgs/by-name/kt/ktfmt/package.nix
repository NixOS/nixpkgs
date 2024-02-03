{ lib, fetchFromGitHub, jre_headless, makeWrapper, maven }:

maven.buildMavenPackage rec {
  pname = "ktfmt";
  version = "0.47";

  src = fetchFromGitHub {
    owner = "facebook";
    repo = "ktfmt";
    rev = "refs/tags/v${version}";
    hash = "sha256-vdvKHTTD84OAQacv/VE/5BxYdW4n3bxPUHF2MdH+sQQ=";
  };

  mvnHash = "sha256-Cl7P2i4VFJ/yk7700u62YPcacfKkhBztFvcDkYBfZEA=";

  nativeBuildInputs = [ makeWrapper ];

  installPhase = ''
    runHook preInstall

    mkdir -p $out/bin
    install -Dm644 core/target/ktfmt-*-jar-with-dependencies.jar $out/share/ktfmt/ktfmt.jar

    makeWrapper ${jre_headless}/bin/java $out/bin/ktfmt \
      --add-flags "-jar $out/share/ktfmt/ktfmt.jar"

    runHook postInstall
  '';

  meta = with lib; {
    description = "A program that reformats Kotlin source code to comply with the common community standard for Kotlin code conventions.";
    homepage = "https://github.com/facebook/ktfmt";
    license = licenses.asl20;
    mainProgram = "ktfmt";
    maintainers = with maintainers; [ ghostbuster91 ];
    inherit (jre_headless.meta) platforms;
  };
}
