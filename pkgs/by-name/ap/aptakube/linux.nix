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
    sha256 = "sha256-BN5JPYxckC3uys2ubN8GkgeGmkpYsPQctr3+xkTPqSM=";
  };

  nativeBuildInputs = [
    autoPatchelfHook
    dpkg
  ];

  buildInputs = [ webkitgtk_4_1 ];

  unpackPhase = ''
    dpkg -X $src .
  '';

  installPhase = ''
    mkdir -p $out
    cp -r usr/share usr/bin $out
  '';
}
