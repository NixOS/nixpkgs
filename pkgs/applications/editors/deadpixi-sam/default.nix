{ stdenv, fetchFromGitHub, freetype, libX11, libXt, libXft
}:

stdenv.mkDerivation rec {
  name = "deadpixi-sam-unstable";
  version = "2016-09-15";
    src = fetchFromGitHub {
      owner = "deadpixi";
      repo = "sam";
      rev = "a6a8872246e8634d884b0ce52bc3be9770ab1b0f";
      sha256 = "1zr8dl0vp1xic3dq69h4bp2fcxsjhrzasfl6ayvkibjd6z5dn07p";
    };

  postPatch = ''
    substituteInPlace config.mk.def \
      --replace "/usr/include/freetype2" "${freetype.dev}/include/freetype2"
  '';

  makeFlags = [ "DESTDIR=$(out)" ];
  buildInputs = [ libX11 libXt libXft ];

  postInstall = ''
    mkdir -p $out/share/applications
    mv deadpixi-sam.desktop $out/share/applications
  '';

  meta = with stdenv.lib; {
    inherit (src.meta) homepage;
    description = "Updated version of the sam text editor";
    license = with licenses; lpl-102;
    maintainers = with maintainers; [ ramkromberg ];
    platforms = with platforms; linux;
  };
}
