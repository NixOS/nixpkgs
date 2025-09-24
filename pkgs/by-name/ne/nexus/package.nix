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
  version = "3.70.1-02";

  src = fetchurl {
    url = "https://download.sonatype.com/nexus/3/nexus-${version}-unix.tar.gz";
    hash = "sha256-oBappm8WRcgyD5HWqJKPbMHjlwCUo9y5+FtB2Kq1PCE=";
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
    knownVulnerabilities = [
      "Nexus 3.77 + 3.78 fixed a bunch of security issues: https://help.sonatype.com/en/sonatype-nexus-repository-3-78-0-release-notes.html"
      "CVE-2024-47554"
      "CVE-2024-5764"
      "Sonatype-2015-0286"
      "Sonatype-2022-6438"
      "CVE-2023-6378"
      "CVE-2023-4218"
    ];
    maintainers = with lib.maintainers; [ ];
  };
}
