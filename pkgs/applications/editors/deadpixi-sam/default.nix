{ lib, stdenv, fetchFromGitHub, freetype, libX11, libXi, libXt, libXft }:

stdenv.mkDerivation rec {
  version = "2017-10-27";
  pname = "deadpixi-sam-unstable";

  src = fetchFromGitHub {
    owner = "deadpixi";
    repo = "sam";
    rev = "51693780fb1457913389db6634163998f9b775b8";
    sha256 = "0nfkj93j4bgli4ixbk041nwi14rabk04kqg8krq4mj0044m1qywr";
  };

  postPatch = ''
    substituteInPlace config.mk.def \
      --replace "/usr/include/freetype2" "${freetype.dev}/include/freetype2" \
      --replace "CC=gcc" ""
  '';

  CFLAGS = "-D_DARWIN_C_SOURCE";
  makeFlags = [ "DESTDIR=$(out)" ];
  buildInputs = [ libX11 libXi libXt libXft ];

  postInstall = ''
    mkdir -p $out/share/applications
    mv deadpixi-sam.desktop $out/share/applications
  '';

  meta = with lib; {
    inherit (src.meta) homepage;
    description = "Updated version of the sam text editor";
    license = with licenses; lpl-102;
    maintainers = with maintainers; [ ramkromberg ];
    platforms = with platforms; unix;
  };
}
