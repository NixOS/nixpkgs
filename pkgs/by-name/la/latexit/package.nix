{ stdenv
, xcodeenv
, fetchurl
, unzip
, makeWrapper
, lib
, texlive
, writeScript
}: stdenv.mkDerivation rec {
  pname = "latexit";
  version = "2.16.5";

  src = fetchurl {
    url = "https://pierre.chachatelier.fr/latexit/downloads/LaTeXiT-source-${builtins.replaceStrings ["."] ["_"] version}.zip";
    hash = "sha256-A2c63bf8v60GtaNfSwuylMp4f4caPpA/AerzJKQVo5c=";
  };

  patches = [ ./ignore-code-signing.patch ./remove-auto-updates.patch ];

  sourceRoot = "./LaTeXiT-mainline";

  nativeBuildInputs =
    let
      xcode = xcodeenv.composeXcodeWrapper { version = "15.0"; };
    in
    [
      unzip
      xcode
      makeWrapper
    ];

  buildPhase = ''
    runHook preBuild
    export LD=$CXX
    xcodebuild clean build -project LaTeXiT-10_9+.xcodeproj -scheme LaTeXiT -verbose -configuration Deployment -derivedDataPath DerivedData
    runHook postBuild
  '';

  installPhase = ''
    runHook preInstall
    mkdir -p $out/Applications
    cp -r DerivedData/Build/Products/Deployment/LaTeXiT.app $out/Applications
    wrapProgram $out/Applications/LaTeXiT.app/Contents/MacOS/LaTeXiT --prefix PATH : ${lib.makeBinPath [ texlive.combined.scheme-full ]}
    codesign --force --deep -s - $out/Applications/LaTeXiT.app
    runHook postInstall
  '';

  passthru.updateScript = ./update.sh;

  meta = with lib; {
    description = "Graphical interface for LaTeX";
    longDescription = ''Should LaTeXiT be categorized, it would be an equation editor. This is not the plain truth, since LaTeXiT is "simply" a graphical interface above a LaTeX engine. However, its large set of features is a reason to see it as an editor; this is the goal in fact'';
    homepage = "https://www.chachatelier.fr/latexit/";
    changelog = "https://pierre.chachatelier.fr/latexit/downloads/latexit-changelog-en.html#version-${version}";
    license = licenses.cecill20;
    platforms = platforms.darwin;
    maintainers = with maintainers; [ samuel-martineau ];
  };
}

