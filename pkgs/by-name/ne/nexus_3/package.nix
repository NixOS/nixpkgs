{
  lib,
  stdenv,
  fetchurl,
  makeWrapper,
  jdk21_headless,
  nixosTests,
}:

stdenv.mkDerivation rec {
  pname = "nexus";
  version = "3.96.3-01";
  strictDeps = true;
  __structuredAttrs = true;

  src = fetchurl {
    url = "https://download.sonatype.com/nexus/3/nexus-${version}-linux-x86_64.tar.gz";
    hash = "sha256-Yo1U0GoA0Lc68Dl3oIu8u1YZOxlbjVlO7P5MMSuI5vE=";
  };

  preferLocalBuild = true;

  sourceRoot = "${pname}-${version}";

  nativeBuildInputs = [ makeWrapper ];

  patches = [
    ./nexus-bin.patch
    ./nexus-vm-opts.patch
  ];

  postPatch = ''
    substituteInPlace bin/nexus.vmoptions \
      --replace-fail ../sonatype-work /var/lib/sonatype-work \
      --replace-fail =. =$out
  '';

  installPhase = ''
    runHook preInstall

    mkdir -p $out
    cp -rfv * $out
    # Remove bundled runtime
    rm -fvr $out/jdk/
    rm -fv $out/bin/nexus.bat

    wrapProgram $out/bin/nexus \
      --set-default APP_JAVA_HOME ${jdk21_headless} \
      --set ALTERNATIVE_NAME "nexus"

    runHook postInstall
  '';

  passthru.tests = {
    inherit (nixosTests) nexus;
  };

  meta = {
    description = "Repository manager for binary software components";
    homepage = "https://www.sonatype.com/products/sonatype-nexus-oss";
    sourceProvenance = with lib.sourceTypes; [ binaryBytecode ];
    license = lib.licenses.epl10;
    platforms = lib.platforms.all;
    maintainers = with lib.maintainers; [
      transcaffeine
    ];
  };
}
