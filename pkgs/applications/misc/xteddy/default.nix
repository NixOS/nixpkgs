{ lib, stdenv, fetchFromGitLab, pkg-config, xorg, imlib2, makeWrapper }:

stdenv.mkDerivation rec {
  pname = "xteddy";
  version = "2.2-5";
  src = fetchFromGitLab {
    domain = "salsa.debian.org";
    owner = "games-team";
    repo = pname;
    rev = "debian/${version}";
    sha256 = "0rm7w78d6qajq4fvi4agyqm0c70f3c1i0cy2jdb6kqql2k8w78qy";
  };

  nativeBuildInputs = [ pkg-config makeWrapper ];
  buildInputs = [ imlib2 xorg.libX11 xorg.libXext ];

  patches = [ "${src}/debian/patches/10_libXext.patch" "${src}/debian/patches/wrong-man-page-section.patch" ];

  postPatch = ''
    sed -i "s:/usr/games/xteddy:$out/bin/xteddy:" xtoys
    sed -i "s:/usr/share/xteddy:$out/share/xteddy:" xtoys
  '';

  postInstall = ''
    cp -R images $out/share/images
    # remove broken test script
    rm $out/bin/xteddy_test
  '';

  postFixup = ''
    # this is needed, because xteddy expects images to reside
    # in the current working directory
    wrapProgram $out/bin/xteddy --chdir "$out/share/images/"
  '';

  meta = with lib; {
    description = "Cuddly teddy bear for your X desktop";
    homepage = "https://weber.itn.liu.se/~stegu/xteddy/";
    license = licenses.gpl2;
    maintainers = [ maintainers.xaverdh ];
    platforms = platforms.linux;
  };
}
