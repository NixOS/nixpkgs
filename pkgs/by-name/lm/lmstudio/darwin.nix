{ stdenv
, fetchurl
, undmg
, meta
, pname
, version
}:
stdenv.mkDerivation {
  inherit meta pname version;

  src = fetchurl {
    url = "https://releases.lmstudio.ai/mac/arm64/${version}/latest/LM-Studio-${version}-arm64.dmg";
    hash = "sha256-zLbkb33Fmz2b+cloEINJybuj+i3ya+EVxb5CPWo/iXk=";
  };

  nativeBuildInputs = [ undmg ];

  sourceRoot = ".";

  installPhase = ''
    runHook preInstall
    mkdir -p $out/Applications
    cp -r *.app $out/Applications
    runHook postInstall
  '';
}

