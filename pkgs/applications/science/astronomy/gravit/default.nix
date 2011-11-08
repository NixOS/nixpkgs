{ stdenv, fetchurl, SDL, SDL_ttf, SDL_image, mesa, lua5_0 }:

let
  name = "gravit-0.4.2";
in
stdenv.mkDerivation {
  inherit name;

  src = fetchurl {
    url = "http://gravit.slowchop.com/dist/${name}.tar.gz";
    sha256 = "f37f3ac256a4acbf575f709addaae8cb01eda4f85537affa28c45f2df6fddb07";
  };

  buildInputs = [mesa SDL SDL_ttf SDL_image lua5_0];

  configureFlags = "CFLAGS=-O3 CXXFLAGS=-O3";

  postInstall = ''
    mv $out/etc/gravit $out/share/gravit/sample-config
    rmdir $out/etc
  '';

  meta = {
    homepage = "http://gravit.slowchop.com";
    description = "A beautiful OpenGL-based gravity simulator";
    license = "GPLv2";

    longDescription = ''
      Gravit is a gravity simulator which runs under Linux, Windows and
      Mac OS X. It uses Newtonian physics using the Barnes-Hut N-body
      algorithm. Although the main goal of Gravit is to be as accurate
      as possible, it also creates beautiful looking gravity patterns.
      It records the history of each particle so it can animate and
      display a path of its travels. At any stage you can rotate your
      view in 3D and zoom in and out.
    '';

    platforms = stdenv.lib.platforms.mesaPlatforms;
    maintainers = [ stdenv.lib.maintainers.simons ];
  };
}
