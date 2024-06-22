{ lib
, stdenv
, fetchFromGitHub
, buildNpmPackage
, curl
, jdk
, jq
, makeWrapper
, maven
, writeText
}:

let
  maven' = maven.override {
    inherit jdk;
  };

  version = "3.8.1";
  src = fetchFromGitHub {
    owner = "openrefine";
    repo = "openrefine";
    rev = version;
    hash = "sha256-MnFwFJdKIU7D8GQgnDvCO+P8r8h1Se/wmbt/Z3EX+3Q=";
  };

  npmPkg = buildNpmPackage {
    inherit src version;

    pname = "openrefine-npm";
    sourceRoot = "${src.name}/main/webapp";

    npmDepsHash = "sha256-u9qledNFqGgMmOIsm2T8w3UoaLbb7WtksUw6xLoRgU8=";

    # package.json doesn't supply a version, which npm doesn't like - fix this.
    # directly referencing jq because buildNpmPackage doesn't pass
    # nativeBuildInputs through to fetchNpmDeps
    postPatch = ''
      NEW_PACKAGE_JSON=$(mktemp)
      ${jq}/bin/jq '. + {version: $ENV.version}' package.json > $NEW_PACKAGE_JSON
      cp $NEW_PACKAGE_JSON package.json
    '';

    dontNpmBuild = true;
    installPhase = ''
      mkdir -p $out
      cp -r modules/core/3rdparty/* $out/
    '';
  };

in maven'.buildMavenPackage {
  inherit src version;

  pname = "openrefine";

  postPatch = ''
    cp -r ${npmPkg} main/webapp/modules/core/3rdparty
  '';
  mvnParameters = "-pl !packaging";
  mvnHash = "sha256-0qsKUMV9M0ZaddR5ust8VikSrsutdxVNNezKqR+F/6M=";

  nativeBuildInputs = [ makeWrapper ];

  doCheck = false;

  installPhase = ''
    mkdir -p $out/lib/server/target/lib
    cp -r server/target/lib/* $out/lib/server/target/lib/
    cp server/target/openrefine-*-server.jar $out/lib/server/target/lib/

    mkdir -p $out/lib/webapp
    cp -r main/webapp/{WEB-INF,modules} $out/lib/webapp/
    (
      cd extensions
      for ext in * ; do
        if [ -d "$ext/module" ] ; then
          mkdir -p "$out/lib/webapp/extensions/$ext"
          cp -r "$ext/module" "$out/lib/webapp/extensions/$ext/"
        fi
      done
    )

    mkdir -p $out/etc
    cp refine.ini $out/etc/

    mkdir -p $out/bin
    cp refine $out/bin/
  '';

  preFixup = ''
    find $out -name '*.java' -delete
    sed -i -E 's|^(butterfly\.modules\.path =).*extensions.*$|\1 '"$out/lib/webapp/extensions|" \
      $out/lib/webapp/WEB-INF/butterfly.properties

    sed -i 's|^cd `dirname \$0`$|cd '"$out/lib|" $out/bin/refine

    cat >> $out/etc/refine.ini <<EOF
    REFINE_WEBAPP='$out/lib/webapp'
    REFINE_LIB_DIR='$out/lib/server/target/lib'

    JAVA_HOME='${jdk.home}'

    # non-headless mode tries to launch a browser, causing a
    # number of purity problems
    JAVA_OPTIONS='-Drefine.headless=true'
    EOF

    wrapProgram $out/bin/refine \
      --prefix PATH : '${lib.makeBinPath [ jdk curl ]}' \
      --set-default REFINE_INI_PATH "$out/etc/refine.ini"
  '';

  passthru = {
    inherit npmPkg;
    updateScript = ./update.sh;
  };

  meta = with lib; {
    description = "Power tool for working with messy data and improving it";
    homepage = "https://openrefine.org";
    license = licenses.bsd3;
    maintainers = with maintainers; [ ris ];
    sourceProvenance = with sourceTypes; [
      fromSource
      binaryBytecode  # maven dependencies
    ];
    broken = stdenv.isDarwin;  # builds, doesn't run
    mainProgram = "refine";
  };
}
