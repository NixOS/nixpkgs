{
  lib,
  fetchFromGitHub,
  jre,
  makeWrapper,
  maven,
  libGL,
  xdg-utils,
  zip,
  zlib,
}:
maven.buildMavenPackage rec {
  pname = "polyglot";
  version = "3.5.1";

  src = fetchFromGitHub {
    owner = "DraqueT";
    repo = "PolyGlot";
    rev = version;
    hash = "sha256-E7wLhohOpWGzXe1zEO9a8aFIVT7/34Wr0dsRzpuf+eY=";
  };

  preBuild = ''
    echo "${version}" > assets/assets/org/DarisaDesigns/version
    cd docs
    zip -r ../assets/assets/org/DarisaDesigns/readme *
    cd ../packaging_files/example_lexicons
    zip -r ../../assets/assets/org/DarisaDesigns/exlex *
    cd ../..
  '';

  mvnHash = "sha256-T7es44oNI9EXnpJd/DvYTb4LaJvR3rIdlhD4s/+Bfks=";
  mvnParameters = "-DskipTests";

  nativeBuildInputs = [
    makeWrapper
    zip
  ];
  runtimeDeps = [
    xdg-utils
    zlib
  ];
  installPhase = ''
    runHook preInstall

    mkdir -p $out/bin $out/share/PolyGlotLinA
    install -Dm644 --target-directory=$out/share/PolyGlotLinA target/PolyGlotLinA-${version}-jar-with-dependencies.jar

    makeWrapper ${jre}/bin/java $out/bin/PolyGlot \
      --add-flags "-Djpackage.app-version=${version}" \
      --add-flags "-jar $out/share/PolyGlotLinA/PolyGlotLinA-${version}-jar-with-dependencies.jar" \
      --prefix LD_LIBRARY_PATH : "${lib.makeLibraryPath [ libGL ]}"

    runHook postInstall
  '';

  meta = {
    description = "Conlang construction toolkit";
    homepage = "https://draquet.github.io/PolyGlot/readme.html";
    changelog = "https://github.com/DraqueT/PolyGlot/releases/tag/${version}";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ noodlez1232 ];
    platforms = lib.platforms.linux;
    mainProgram = "PolyGlot";
  };
}
