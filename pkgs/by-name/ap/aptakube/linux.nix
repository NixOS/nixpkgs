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
    sha256 = "sha256-jksIgYMTjcRclXUooDtQoar0fIsrKB9IFwSMp9D6CZ0=";
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
