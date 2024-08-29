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
  version = "3.69.0-02";

  src = fetchurl {
    url = "https://download.sonatype.com/nexus/3/nexus-${version}-unix.tar.gz";
    hash = "sha256-7sgLPuM93mFEPlTd3qJY+FGVHErvgcTGJWwSBcqBgWI=";
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
      --replace-fail etc/karaf $out/etc/karaf \
      --replace-fail =. =$out
  '';

  installPhase = ''
    runHook preInstall

    mkdir -p $out
    cp -rfv * .install4j $out
    rm -fv $out/bin/nexus.bat

    wrapProgram $out/bin/nexus \
      --set JAVA_HOME ${jre_headless} \
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
      aespinosa
      ironpinguin
      luftmensch-luftmensch
      zaninime
    ];
  };
}
