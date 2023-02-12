{ lib
, stdenv
, fetchFromGitHub
, fetchpatch
, openssl
, libsamplerate
, swig
, alsa-lib
, AppKit
, python3
, pythonSupport ? true
}:

stdenv.mkDerivation rec {
  pname = "pjsip";
  version = "2.13";

  src = fetchFromGitHub {
    owner = pname;
    repo = "pjproject";
    rev = version;
    sha256 = "sha256-yzszmm3uIyXtYFgZtUP3iswLx4u/8UbFt80Ln25ToFE=";
  };

  patches = [
    ./fix-aarch64.patch
    (fetchpatch {
      name = "CVE-2022-23537.patch";
      url = "https://github.com/pjsip/pjproject/commit/d8440f4d711a654b511f50f79c0445b26f9dd1e1.patch";
      sha256 = "sha256-7ueQCHIiJ7MLaWtR4+GmBc/oKaP+jmEajVnEYqiwLRA=";
    })
    (fetchpatch {
      name = "CVE-2022-23547.patch";
      url = "https://github.com/pjsip/pjproject/commit/bc4812d31a67d5e2f973fbfaf950d6118226cf36.patch";
      sha256 = "sha256-bpc8e8VAQpfyl5PX96G++6fzkFpw3Or1PJKNPKl7N5k=";
    })
  ];

  nativeBuildInputs =
    lib.optionals pythonSupport [ swig python3 ];

  buildInputs = [ openssl libsamplerate ]
    ++ lib.optional stdenv.isLinux alsa-lib
    ++ lib.optional stdenv.isDarwin AppKit;

  preConfigure = ''
    export LD=$CC
  '';

  postBuild = lib.optionalString pythonSupport ''
    make -C pjsip-apps/src/swig/python
  '';

  outputs = [ "out" ]
    ++ lib.optional pythonSupport "py";

  configureFlags = [ "--enable-shared" ];

  postInstall = ''
    mkdir -p $out/bin
    cp pjsip-apps/bin/pjsua-* $out/bin/pjsua
    mkdir -p $out/share/${pname}-${version}/samples
    cp pjsip-apps/bin/samples/*/* $out/share/${pname}-${version}/samples
  '' + lib.optionalString pythonSupport ''
    (cd pjsip-apps/src/swig/python && \
      python setup.py install --prefix=$py
    )
  '';

  # We need the libgcc_s.so.1 loadable (for pthread_cancel to work)
  dontPatchELF = true;

  meta = with lib; {
    broken = stdenv.isDarwin;
    description = "A multimedia communication library written in C, implementing standard based protocols such as SIP, SDP, RTP, STUN, TURN, and ICE";
    homepage = "https://pjsip.org/";
    license = licenses.gpl2Plus;
    maintainers = with maintainers; [ olynch ];
    mainProgram = "pjsua";
    platforms = platforms.linux ++ platforms.darwin;
  };
}
