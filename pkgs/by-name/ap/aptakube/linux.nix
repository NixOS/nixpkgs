{
  stdenvNoCC,
  fetchurl,
  dpkg,
  autoPatchelfHook,
  glibc,
  libgcc,
  cairo,
  gtk3,
  libsoup_3,
  webp-pixbuf-loader,
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
    dpkg
    autoPatchelfHook
  ];

  buildInputs = [
    glibc
    libgcc
    cairo.dev
    gtk3.dev
    libsoup_3
    webp-pixbuf-loader
    webkitgtk_4_1
  ];

  unpackPhase = ''
    dpkg -X $src .
  '';

  installPhase = ''
    mkdir -p $out
    mv -v usr/share usr/bin $out
  '';
}
