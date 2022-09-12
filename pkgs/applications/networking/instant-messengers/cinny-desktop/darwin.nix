{ pname
, version
, src
, meta
, stdenvNoCC
, undmg
}:

stdenvNoCC.mkDerivation {
  inherit pname version src meta;

  sourceRoot = "Cinny.app";

  nativeBuildInputs = [
    undmg
  ];

  dontConfigure = true;
  dontBuild = true;

  installPhase = ''
    runHook preInstall

    mkdir -p $out/{Applications/Cinny.app,bin}
    cp -r ./* $out/Applications/Cinny.app
    ln -s $out/Applications/Cinny.app/Contents/MacOS/Cinny $out/bin

    runHook postInstall
  '';
}
