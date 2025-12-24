{
  lib,
  stdenvNoCC,
  fetchFromGitHub,
  fetchurl,
  gradle,
  dart-sass,
  makeWrapper,
  jre,
  python3,
}:

let
  manifest = lib.trivial.importJSON ./manifest.json;
  # not fetchFromGitHub, because it uses fetchzip, which would extract the files automatically, which is not expected.
  xspec =
    with manifest.dependencies.xspec;
    fetchurl {
      url = "https://github.com/xspec/xspec/archive/v${version}.zip";
      hash = hash;
    };
  xsltExplorer =
    with manifest.dependencies.xsltExplorer;
    fetchurl {
      url = "https://github.com/ndw/xsltexplorer/releases/download/${version}/xsltexplorer-${version}.zip";
      hash = hash;
    };
in

stdenvNoCC.mkDerivation (finalAttrs: {
  pname = "docbook-xsltng";
  inherit (manifest) version;

  src = fetchFromGitHub {
    owner = "docbook";
    repo = "xslTNG";
    rev = finalAttrs.version;
    inherit (manifest) hash;
  };

  # These are all for the check phase.
  postPatch = ''
    patchShebangs --build src/test/resources/xspec/xspec.sh

    substituteInPlace build.gradle \
        --replace-fail 'https://github.com/xspec/xspec/archive/v''${xspecVersion}.zip' \
            file://${xspec} \
        --replace-fail 'https://github.com/ndw/xsltexplorer/releases/download/''${xsltExplorerVersion}/xsltexplorer-''${xsltExplorerVersion}.zip' \
            file://${xsltExplorer}

    substituteInPlace src/bin/docbook.py \
        --replace-fail 'str(Path.home())' \
            \"$PWD/nix-temp/home\"
  '';

  nativeBuildInputs =
    [
      gradle
      dart-sass
      makeWrapper
      python3
    ]
    ++ (with python3.pkgs; [
      pygments
      click
    ]);

  mitmCache = gradle.fetchDeps {
    inherit (finalAttrs) pname;
    data = ./deps.json;
  };

  __darwinAllowLocalNetworking = true;

  gradleFlags = map (propDef: "-P" + propDef) [
    "requireCompileSuccess=true"
    "requireTestSuccess=true"
    /*
      Although we should keep the versions of dependencies consistent with the upstream,
      coercing the build system to follow ours does no harm and provides extra robustness.
    */
    "xspecVersion=${manifest.dependencies.xspec.version}"
    "xsltExplorerVersion=${manifest.dependencies.xsltExplorer.version}"
  ];

  gradleBuildTask = [
    "makeXslt"
    "jar"
    "guide"
  ];

  doCheck = true;

  nativeCheckInputs =
    [ jre ]
    ++ (with python3.pkgs; [
      cython
      # saxonche # FIXME: Not available in Nixpkgs.
      lxml
      html5-parser
    ]);

  preCheck = ''
    mkdir -p nix-temp/home
  '';

  gradleCheckTask = [ "test" ];

  /*
    The executable uses the same name as the upstream Python script, since
    > This script behaves much like the JAR file described in Section 2.1, “Using the Jar”.
    > In particular, it accepts the same command line options as Saxon, with the same caveats.
  */
  installPhase = ''
    runHook preInstall

    dst_xslt=$out/share/xml/docbook-xslTNG
    dst_jar=$out/share/docbook-xslTNG
    dst_bin=$out/bin
    dst_doc=$out/share/doc/docbook-xslTNG
    mkdir -p $dst_xslt $dst_jar $dst_bin $dst_doc

    cp -pr -t $dst_xslt build/xslt/*
    cp -pr -t $dst_jar build/libs/*
    makeWrapper ${jre}/bin/java $dst_bin/docbook \
        --add-flags "-jar $dst_jar/docbook-xslTNG-${finalAttrs.version}.jar"
    cp -pr -t $dst_doc build/guide/*

    runHook postInstall
  '';

  passthru.updateScript = {
    command = ./update.py;
    supportedFeatures = [ "commit" ];
  };

  meta = {
    description = "Next Generation of DocBook stylesheets in XSLT";
    longDescription = ''
      These are XSLT 3.0 stylesheets for DocBook. They transform DocBook XML
      documents into clean, semantically rich HTML5. A CSS stylesheet suitable
      for online presentation is included. Producing high quality print output
      with a paged media capable CSS processor is also supported.

      The resources referred to by the generated HTML files can be find in
      [the DocBook CDN](https://cdn.docbook.org/release/xsltng/${finalAttrs.version}/resources/).
      You can make the files point to them by changing the parameter
      `$resource-base-uri`.
    '';
    homepage = "https://xsltng.docbook.org/";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ rc-zb ];
    mainProgram = "docbook";
    platforms = lib.platforms.unix;
    sourceProvenance = with lib.sourceTypes; [
      fromSource
      binaryBytecode
    ];
  };
})
