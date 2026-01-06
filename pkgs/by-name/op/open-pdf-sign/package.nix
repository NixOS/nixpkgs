{
  jre,
  lib,
  makeBinaryWrapper,
  nix-update-script,
  fetchFromGitHub,
  maven,
}:

maven.buildMavenPackage rec {
  version = "0.3.0";
  pname = "open-pdf-sign";

  src = fetchFromGitHub {
    owner = "open-pdf-sign";
    repo = "open-pdf-sign";
    tag = "v${version}";
    hash = "sha256-4PkTm9nsIsCrXaLJePDvGalO726BVKhbK2bpFzg9ec0=";
  };

  postPatch = ''
    # Get package version from CLI, not from git(which doesn't exist in the build environment)
    substituteInPlace pom.xml \
      --replace-fail 'hint="git"' 'hint="sysprop"' \

    sed -i '/dirtyQualifier/d' ./pom.xml
  '';

  mvnHash = "sha256-5DgCjqKPc/y4vDX8pl4Qnm1KsCOpCdUVNiihpvcCzBU=";

  # Disable test requires the network, we also set the version
  mvnParameters = lib.escapeShellArgs [
    "-Dtest=!SignerTest#testSignPdf"
    "-Dexternal.version=${version}"
  ];

  nativeBuildInputs = [
    makeBinaryWrapper
  ];

  installPhase = ''
    runHook preInstall

    mkdir -p $out/bin $out/share/open-pdf-sign
    mv target/openpdfsign-${version}-jar-with-dependencies.jar $out/share/open-pdf-sign/open-pdf-sign.jar

    makeWrapper ${lib.getExe jre} $out/bin/open-pdf-sign \
      --add-flags "-jar $out/share/open-pdf-sign/open-pdf-sign.jar"

    runHook postInstall
  '';

  passthru = {
    updateScript = nix-update-script { };
  };

  meta = {
    description = "Digitally sign PDF files from your commandline";
    homepage = "https://github.com/open-pdf-sign/open-pdf-sign";
    license = lib.licenses.asl20;
    maintainers = [ ];
    mainProgram = "open-pdf-sign";
  };
}
