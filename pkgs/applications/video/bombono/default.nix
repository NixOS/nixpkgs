{ lib, stdenv
, fetchFromGitHub
, pkg-config
, fetchpatch
, scons
, boost
, dvdauthor
, dvdplusrwtools
, enca
, cdrkit
, ffmpeg_4
, gettext
, gtk2
, gtkmm2
, libdvdread
, libxmlxx
, mjpegtools
, wrapGAppsHook
}:

let
  fetchPatchFromAur = {name, sha256}:
    fetchpatch {
      inherit name sha256;
      url = "https://aur.archlinux.org/cgit/aur.git/plain/${name}?h=766dd4ba1715fc921fe26ce1bdcf22c30f4fc073";
    };
in
stdenv.mkDerivation rec {
  pname = "bombono";
  version = "1.2.4";

  src = fetchFromGitHub {
    owner = "bombono-dvd";
    repo = "bombono-dvd";
    rev = version;
    sha256 = "sha256-aRW8H8+ca/61jGLxUs7u3R7yEiulwr5viMEuZWbc4dM=";
  };

  patches = [
    (fetchpatch {
      name = "bombono-dvd-1.2.4-scons3.patch";
      url = "https://svnweb.mageia.org/packages/cauldron/bombono-dvd/current/SOURCES/bombono-dvd-1.2.4-scons-python3.patch?revision=1447925&view=co&pathrev=1484457";
      sha256 = "sha256-5OKBWrRZvHem2MTdAObfdw76ig3Z4ZdDFtq4CJoJISA=";
    })
  ] ++ (map fetchPatchFromAur [
    {name="fix_ffmpeg_codecid.patch";         sha256="sha256-58L+1BJy5HK/R+xALbq2z4+Se4i6yp21lo/MjylgTqs=";}
    {name="fix_ptr2bool_cast.patch";          sha256="sha256-DyqMw/m2Op9+gBq1CTCjSZ1qM9igV5Y6gTOi8VbNH0c=";}
    {name="fix_c++11_literal_warnings.patch"; sha256="sha256-iZ/CN5+xg7jPXl5r/KGCys+jyPu0/AsSABLcc6IIbv0=";}
    {name="autoptr2uniqueptr.patch";          sha256="sha256-teGp6uICB4jAJk18pdbBMcDxC/JJJGkdihtXeh3ffCg=";}
    {name="fix_deprecated_boost_api.patch";   sha256="sha256-qD5QuO/ndEU1N7vueQiNpPVz8OaX6Y6ahjCWxMdvj6A=";}
    {name="fix_throw_specifications.patch";   sha256="sha256-NjCDGwXRCSLcuW2HbPOpXRgNvNQHy7i7hoOgyvGIr7g=";}
    {name="fix_operator_ambiguity.patch";     sha256="sha256-xx7WyrxEdDrDuz5YoFrM/u2qJru9u6X/4+Y5rJdmmmQ=";}
    {name="fix_ffmpeg30.patch";               sha256="sha256-vKEbvbjYVRzEaVYC8XOJBPmk6FDXI/WA0X/dldRRO8c=";}
    {name="inc_boost_header.patch";           sha256="sha256-76vjkf62VsNJ5FmBEs+X7ZBqjvJ372mjSIreBxNQym8=";}
  ]);

  postPatch = ''
    substituteInPlace src/mbase/SConscript \
      --replace "lib_mbase_env['CPPDEFINES']" "list(lib_mbase_env['CPPDEFINES'])"
  '';

  nativeBuildInputs = [ wrapGAppsHook scons pkg-config gettext ];

  buildInputs = [
    boost
    dvdauthor
    dvdplusrwtools
    enca
    ffmpeg_4
    gtk2
    gtkmm2
    libdvdread
    libxmlxx
    mjpegtools
  ];

  prefixKey = "PREFIX=";

  enableParallelBuilding = true;

  postInstall = ''
    # fix iso authoring
    install -Dt  $out/share/bombono/resources/scons_authoring tools/scripts/SConsTwin.py

    wrapProgram $out/bin/bombono-dvd --prefix PATH : ${lib.makeBinPath [ ffmpeg_4 dvdauthor cdrkit ]}
  '';

  meta = with lib; {
    description = "a DVD authoring program for personal computers";
    homepage = "https://www.bombono.org/";
    license = licenses.gpl2Only;
    maintainers = with maintainers; [ symphorien ];
    platforms = platforms.linux;
  };
}
