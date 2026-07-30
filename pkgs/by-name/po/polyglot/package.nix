{
  lib,
  stdenv,
  fetchFromGitHub,
  jre,
  makeWrapper,
  maven,
  libGL,
  xdg-utils,
  libxxf86vm,
  zip,
  zlib,
}:
maven.buildMavenPackage rec {
  pname = "polyglot";
  version = "3.6.1";

  src = fetchFromGitHub {
    owner = "DraqueT";
    repo = "PolyGlot";
    tag = "v${version}";
    hash = "sha256-jDW74Hk+6vzCUm84wwMn5XBGPVlsJ3mQrjtuqMZssz0=";
  };

  preBuild = ''
    echo "${version}" > assets/assets/org/DarisaDesigns/version
    cd docs
    zip -r ../assets/assets/org/DarisaDesigns/readme *
    cd ../packaging_files/example_lexicons
    zip -r ../../assets/assets/org/DarisaDesigns/exlex *
    cd ../..
  '';

  mvnHash =
    {
      aarch64-linux = "sha256-o5dFk1pghCOaaxAto7e5kXn2mrVEGAtb9kTwQQN2N8o=";
      x86_64-linux = "sha256-KYgeVBhqBjP6dqwpSzoqH8dfsL4WpJcSiHEMfgk0CNE=";
    }
    .${stdenv.hostPlatform.system} or (throw "Unsupported system: ${stdenv.hostPlatform.system}");
  mvnFetchExtraArgs.env = {
    inherit (env) SOURCE_DATE_EPOCH;
  };

  # fix for "date 1980-01-01T00:00:00Z is not within the valid range 1980-01-01T00:00:02Z to 2099-12-31T23:59:59Z"
  env.SOURCE_DATE_EPOCH = 315532802; # 1980-01-01T00:00:02Z

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
      --prefix LD_LIBRARY_PATH : "${
        lib.makeLibraryPath [
          libGL
          libxxf86vm
        ]
      }"

    runHook postInstall
  '';

  meta = {
    description = "Conlang construction toolkit";
    homepage = "https://draquet.github.io/PolyGlot/readme.html";
    changelog = "https://github.com/DraqueT/PolyGlot/releases/tag/v${version}";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ noodlez1232 ];
    platforms = lib.platforms.linux;
    mainProgram = "PolyGlot";
  };
}
