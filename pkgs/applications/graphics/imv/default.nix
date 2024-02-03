{ stdenv
, lib
, fetchFromSourcehut
, asciidoc
, cmocka
, docbook_xsl
, libxslt
, meson
, ninja
, pkg-config
, icu
, pango
, inih
, withWindowSystem ? null
, xorg
, libxkbcommon
, libGLU
, wayland
, withBackends ? [ "freeimage" "libtiff" "libjpeg" "libpng" "librsvg" "libnsgif" "libheif" ]
, freeimage
, libtiff
, libjpeg_turbo
, libpng
, librsvg
, netsurf
, libheif
}:

let
  # default value of withWindowSystem
  withWindowSystem' =
         if withWindowSystem != null then withWindowSystem
    else if stdenv.isLinux then "all"
    else "x11";

  windowSystems = {
    all = windowSystems.x11 ++ windowSystems.wayland;
    x11 = [ libGLU xorg.libxcb xorg.libX11 ];
    wayland = [ wayland ];
  };

  backends = {
    inherit freeimage libtiff libpng librsvg libheif;
    libjpeg = libjpeg_turbo;
    inherit (netsurf) libnsgif;
  };

  backendFlags = builtins.map
    (b: if builtins.elem b withBackends
        then "-D${b}=enabled"
        else "-D${b}=disabled")
    (builtins.attrNames backends);
in

# check that given window system is valid
assert lib.assertOneOf "withWindowSystem" withWindowSystem'
  (builtins.attrNames windowSystems);
# check that every given backend is valid
assert builtins.all
  (b: lib.assertOneOf "each backend" b (builtins.attrNames backends))
  withBackends;

stdenv.mkDerivation rec {
  pname = "imv";
  version = "4.4.0";
  outputs = [ "out" "man" ];

  src = fetchFromSourcehut {
    owner = "~exec64";
    repo = "imv";
    rev = "v${version}";
    sha256 = "sha256-LLEEbriHzZhAOQivqHqdr6g7lh4uj++ytlme8AfRjf4=";
  };

  mesonFlags = [
    "-Dwindows=${withWindowSystem'}"
    "-Dtest=enabled"
    "-Dman=enabled"
  ] ++ backendFlags;

  strictDeps = true;

  nativeBuildInputs = [
    asciidoc
    docbook_xsl
    libxslt
    meson
    ninja
    pkg-config
  ];

  buildInputs = [
    cmocka
    icu
    libxkbcommon
    pango
    inih
  ] ++ windowSystems."${withWindowSystem'}"
    ++ builtins.map (b: backends."${b}") withBackends;

  postInstall = ''
    # fix the executable path and install the desktop item
    substituteInPlace ../files/imv.desktop --replace "imv %F" "$out/bin/imv %F"
    install -Dm644 ../files/imv.desktop $out/share/applications/
  '';

  postFixup = lib.optionalString (withWindowSystem' == "all") ''
    # The `bin/imv` script assumes imv-wayland or imv-x11 in PATH,
    # so we have to fix those to the binaries we installed into the /nix/store

    substituteInPlace "$out/bin/imv" \
      --replace "imv-wayland" "$out/bin/imv-wayland" \
      --replace "imv-x11" "$out/bin/imv-x11"
  '';

  doCheck = true;

  meta = with lib; {
    description = "A command line image viewer for tiling window managers";
    homepage = "https://sr.ht/~exec64/imv/";
    license = licenses.mit;
    maintainers = with maintainers; [ rnhmjoj markus1189 ];
    platforms = platforms.all;
    badPlatforms = platforms.darwin;
  };
}
