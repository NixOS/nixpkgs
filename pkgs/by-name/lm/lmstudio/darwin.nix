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
    url = "https://releases.lmstudio.ai/darwin/arm64/${version}/LM-Studio-${version}-arm64.dmg";
    hash = "sha256-PmXekM7rHY8EIp6l2XiLQlxyIB00MJS5C0gzFfe1i70=";
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

