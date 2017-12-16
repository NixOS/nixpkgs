{ stdenv, fetchgit, cmake, pkgconfig, zlib, libpng, cairo, freetype
, json_c, fontconfig, gtkmm2, pangomm, glew, mesa_glu, xlibs, pcre
, wrapGAppsHook
}:
stdenv.mkDerivation rec {
  name = "solvespace-2.x";
  rev = "b1d87bf284b32e875c8edba592113e691ea10bcd";
  src = fetchgit {
    url = https://github.com/solvespace/solvespace.git;
    inherit rev;
    fetchSubmodules = true;
    sha256 = "160qam04pfrwkh9qskfmjkj01wrjwhl09xi6jjxi009yqg3cff9l";
  };

  nativeBuildInputs = [
    pkgconfig cmake wrapGAppsHook
  ];
  buildInputs = [
    zlib libpng cairo freetype
    json_c fontconfig gtkmm2 pangomm glew mesa_glu
    xlibs.libpthreadstubs xlibs.libXdmcp pcre
  ];
  enableParallelBuilding = true;

  preConfigure = ''
    patch CMakeLists.txt <<EOF
    @@ -20,9 +20,9 @@
     # NOTE TO PACKAGERS: The embedded git commit hash is critical for rapid bug triage when the builds
     # can come from a variety of sources. If you are mirroring the sources or otherwise build when
     # the .git directory is not present, please comment the following line:
    -include(GetGitCommitHash)
    +# include(GetGitCommitHash)
     # and instead uncomment the following, adding the complete git hash of the checkout you are using:
    -# set(GIT_COMMIT_HASH 0000000000000000000000000000000000000000)
    +set(GIT_COMMIT_HASH $rev)
    EOF
  '';

  postInstall = ''
    substituteInPlace $out/share/applications/solvespace.desktop \
      --replace /usr/bin/ $out/bin/
  '';

  meta = with stdenv.lib; {
    description = "A parametric 3d CAD program";
    license = licenses.gpl3;
    maintainers = [ maintainers.edef ];
    platforms = platforms.linux;
    homepage = http://solvespace.com;
  };
}
