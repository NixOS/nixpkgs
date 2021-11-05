{ lib
, stdenv
, fetchFromGitHub
, fetchpatch
, wafHook
, python3
, pkg-config
, boost
, bzip2
, cairomm
, curl
, ffmpeg
, fontconfig
, glib
, gtk2
, icu
, leqm-nrt
, libcxml
, libdcp
, libGLU
, libpng
, libsamplerate
, libsndfile
, libssh
, libsub
, libtool
, libxmlxx
, libzip
, nanomsg
, nettle
, openssl
, pangomm
, rtaudio
, wxGTK31
, xmlsec
, substitute
}:

let
  openssl-cth = openssl.overrideAttrs (oldAttrs: {
    version = "${oldAttrs.version}-dcpomatic";
    patches = (oldAttrs.patches or []) ++ [
      (fetchpatch {
        url = "https://github.com/cth103/openssl/commit/752ff83f31327c91dfd45fbc6cb14e6d9c807e44.patch";
        sha256 = "0xay54xxl0vjvigaxdfvgykrmlv9cgym6d2cc7acc5blggdzzlqf";
      })
    ];
  });
in stdenv.mkDerivation rec {
  pname = "dcpomatic";
  version = "2.15.183";

  src = fetchFromGitHub {
    owner = "cth103";
    repo = "dcpomatic";
    rev = "v${version}";
    sha256 = "0srllj5vwnxhc3p3grvf92ymdvlg4z9lx5bbxrbx6l3prkyp2933";
  };

  patches = [
    # libdcp's data files are not in a shared /share/ directory.
    (substitute {
      src = ./libdcp-path.patch;
      replacements = [ "--replace" "@LIBDCP@" libdcp ];
    })
    # fixes to add correct headers
    (fetchpatch {
      url = "https://github.com/cth103/dcpomatic/pull/14/commits/cbcbbc1cf6f6faf18991e92f2e2917fc14a00116.patch";
      sha256 = "0grdf5jdnbhnlw45f8v301z4gk3k64j3xqifdxfkakankgj3mxfw";
    })
  ];

  postPatch = ''
    substituteInPlace wscript \
      --replace "this_version = " "this_version = 'v${version}' #" \
      --replace "last_version = " "last_version = 'v${version}' #"
  '';

  wafConfigureFlags = [
    "--disable-tests"

    # requires lwext4
    # "--enable-disk"
  ];

  enableParallelBuilding = true;

  buildInputs = [
    boost
    bzip2
    cairomm
    curl
    ffmpeg
    fontconfig
    glib
    gtk2
    icu
    leqm-nrt
    libcxml
    libdcp
    libGLU
    libpng
    libsamplerate
    libsndfile
    libssh
    libsub
    libtool
    libxmlxx
    libzip
    nanomsg
    nettle
    pangomm
    rtaudio
    wxGTK31
    xmlsec
  ];

  nativeBuildInputs = [
    wafHook
    python3
    pkg-config
  ];

  postInstall = ''
    ln -s ${openssl-cth}/bin/openssl $out/bin/dcpomatic2_openssl
  '';

  meta = with lib; {
    description = "Program for converting video, audio and subtitles to Digital Cinema Packages";
    homepage = "https://dcpomatic.com";
    license = licenses.gpl2Plus;
    maintainers = with maintainers; [ lukegb ];
  };
}
