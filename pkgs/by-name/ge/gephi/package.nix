{
  lib,
  fetchFromGitHub,
  jdk,
  maven,
}:

maven.buildMavenPackage (finalAttrs: {
  pname = "gephi";
  version = "0.11.4";
  __structuredAttrs = true;
  strictDeps = true;

  src = fetchFromGitHub {
    owner = "gephi";
    repo = "gephi";
    tag = "v${finalAttrs.version}";
    hash = "sha256-4e1Pt2jUzEaE3BiOFCIei6BFL6yrneARn9FY6bbKSMI=";
  };

  mvnJdk = jdk;
  mvnHash = "sha256-z7i71feg66BEM1w8KcZrucQDi0sO2E2DrTS8OKF1yoA=";

  nativeBuildInputs = [ jdk ];

  installPhase = ''
    runHook preInstall

    cp -r modules/application/target/gephi $out

    # remove garbage
    find $out -type f -name  .lastModified -delete
    find $out -type f -regex '.+\.exe'     -delete

    printf "\n\njdkhome=${jdk}\n" >> $out/etc/gephi.conf

    runHook postInstall
  '';

  # Tests are failing with something related to ByteBuddyAgent
  doCheck = false;

  meta = {
    description = "Platform for visualizing and manipulating large graphs";
    mainProgram = "gephi";
    homepage = "https://gephi.org";
    sourceProvenance = with lib.sourceTypes; [
      fromSource
      binaryBytecode # deps
    ];
    license = lib.licenses.gpl3;
    maintainers = [ lib.maintainers.taeer ];
  };
})
