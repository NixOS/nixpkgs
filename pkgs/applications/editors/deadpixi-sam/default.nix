{ stdenv, fetchFromGitHub, freetype, libX11, libXt, libXft
, version ? "2016-10-08"
, rev ? "a17c4a9c2a1af2de0a756fe16d482e0db88c0541"
, sha256 ? "03xmfzlijz4gbmr7l0pb1gl9kmlz1ab3hr8d51innvlasy4g6xgj"
}:

stdenv.mkDerivation rec {
  inherit version;
  name = "deadpixi-sam-unstable-${version}";
    src = fetchFromGitHub {
      inherit sha256 rev;
      owner = "deadpixi";
      repo = "sam";
    };

  postPatch = ''
    substituteInPlace config.mk.def \
      --replace "/usr/include/freetype2" "${freetype.dev}/include/freetype2" \
      --replace "CC=gcc" ""
  '';

  CFLAGS = "-D_DARWIN_C_SOURCE";
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
    platforms = with platforms; unix;
  };
}
