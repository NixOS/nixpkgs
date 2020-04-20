{ stdenv, fetchFromGitHub, wrapQtAppsHook, cmake, bzip2, qtbase, qttools, libnova, proj, libpng, openjpeg } :

stdenv.mkDerivation rec {
  version = "1.2.6.1";
  pname = "xygrib";

  src = fetchFromGitHub {
    owner = "opengribs";
    repo = "XyGrib";
    rev = "v${version}";
    sha256 = "0xzsm8pr0zjk3f8j880fg5n82jyxn8xf1330qmmq1fqv7rsrg9ia";
  };

  nativeBuildInputs = [ cmake qttools wrapQtAppsHook ];
  buildInputs = [ bzip2 qtbase libnova proj openjpeg libpng ];
  cmakeFlags = [ "-DOPENJPEG_INCLUDE_DIR=${openjpeg.dev}/include/openjpeg-2.3" ];

  postInstall = ''
    wrapQtApp $out/XyGrib/XyGrib
    mkdir -p $out/bin
    ln -s $out/XyGrib/XyGrib $out/bin/xygrib
  '';

  meta = with stdenv.lib; {
    homepage = "https://opengribs.org";
    description = "Weather Forecast Visualization";
    longDescription = ''XyGrib is a leading opensource weather visualization package.
                        It interacts with OpenGribs's Grib server providing a choice
                        of global and large area atmospheric and wave models.'';
    license = licenses.gpl3;
    platforms = platforms.all;
    maintainers = [ maintainers.j03 ];
  };
}
