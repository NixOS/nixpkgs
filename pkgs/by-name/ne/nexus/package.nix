{
  lib,
  stdenv,
  fetchurl,
  makeWrapper,
  jre_headless,
  gawk,
  nixosTests,
}:

stdenv.mkDerivation rec {
  pname = "nexus";
  version = "3.81.1-01";

  src = fetchurl {
    url = "https://download.sonatype.com/nexus/3/nexus-${version}-linux-x86_64.tar.gz";
    hash = "sha256-3CiG/X8WyCx/HkrbUossOnTw6k56eP4ElBq1btxzOjg=";
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
      --set-default APP_JAVA_HOME ${jre_headless} \
      --set ALTERNATIVE_NAME "nexus" \
      --prefix PATH "${lib.makeBinPath [ gawk ]}"

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
