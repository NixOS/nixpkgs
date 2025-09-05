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
    sha256 = "9660c87da400dad1451f685defff774c6f5af9b3f713ad1cbd48284e965457dd";
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
