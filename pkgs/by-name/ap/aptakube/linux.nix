{
  stdenvNoCC,
  fetchurl,
  dpkg,
  autoPatchelfHook,
  webkitgtk_4_1,

  pname,
  version,
  meta,
}:
stdenvNoCC.mkDerivation {
  inherit
    pname
    version
    meta
    ;

  src = fetchurl {
    url = "https://github.com/aptakube/aptakube/releases/download/${version}/aptakube_${version}_amd64.deb";
    sha256 = "sha256-lmDIfaQA2tFFH2hd7/93TG9a+bP3E60cvUgoTpZUV90=";
  };

  nativeBuildInputs = [
    autoPatchelfHook
    dpkg
  ];

  buildInputs = [ webkitgtk_4_1 ];

  unpackPhase = ''
    runHook preUnpack
    dpkg -X $src .
    runHook postUnpack
  '';

  installPhase = ''
    runHook preInstall
    mkdir -p $out
    cp -r usr/share usr/bin $out
    runHook postInstall
  '';
}
