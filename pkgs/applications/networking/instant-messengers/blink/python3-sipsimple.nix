{ lib, fetchFromGitHub, buildPythonPackage, isPy3k, twisted, cython, openssl
, ffmpeg, sqlite, libv4l, libopus, alsaLib, opencore-amr, pkg-config, application
, eventlib, ag-gnutls, otr, msrplib, xcaplib, dateutil, dns, gevent, lxml, x264
, libvpx, iana-etc, libredirect, ... }:
let
  pjsip-src = fetchFromGitHub {
    owner = "pjsip";
    repo = "pjproject";
    rev = "2.10";
    sha256 = "sha256-4BOHrlCqLsjydRv1Ck91FcFSWWklDjDRKQgx/i6LdKo=";
  };
  zrtpcpp-src = fetchFromGitHub {
    owner = "wernerd";
    repo = "ZRTPCPP";
    rev = "6b3cd8e6783642292bad0c21e3e5e5ce45ff3e03";
    sha256 = "sha256-kJlGPVA+yfn7fuRjXU0p234VcZBAf1MU4gRKuPotfog=";
  };
in buildPythonPackage rec {
  pname = "python3-sipsimple";
  version = "5.2.6";

  src =
    fetchFromGitHub {
      name = pname;
      owner = "AGProjects";
      repo = "python3-sipsimple";
      rev = "8271220956f7d76ed467398329530efa4546666a";
      sha256 = "sha256-eDCJHb4RphsykDpt5rCjz/GijfhbBLMLwRUhD4hRc5I=";
    };

  prePatch = ''
    pushd deps
    cp -r ${pjsip-src} ./pjproject-2.10 --no-preserve mode
    cp -r ./pjproject-2.10 ./pjsip

    mkdir ./pjsip/third_party/zsrtp
    cp -r zsrtp/include ./pjsip/third_party/zsrtp/
    cp -r zsrtp/srtp    ./pjsip/third_party/zsrtp/
    cp -r zsrtp/build   ./pjsip/third_party/build/zsrtp

    cp -r ${zrtpcpp-src} ./ZRTPCPP --no-preserve mode
    mkdir ./pjsip/third_party/zsrtp/zrtp
    cp -r ZRTPCPP/bnlib \
          ZRTPCPP/common \
          ZRTPCPP/cryptcommon \
          ZRTPCPP/srtp \
          ZRTPCPP/zrtp \
          ZRTPCPP/COPYING \
          ZRTPCPP/README.md ./pjsip/third_party/zsrtp/zrtp/
  '';

  patches =
    let patchDir = "${src}/deps/patches/";
        patchBaseNames = builtins.attrNames (builtins.readDir patchDir);
    in  map (bn: patchDir + bn) patchBaseNames;

  patchFlags = "-p0";

  postPatch = ''
    popd
  '';

  preConfigure = ''
    chmod +x deps/pjsip/configure
    chmod +x deps/pjsip/aconfigure
    export LD=$CC
  '';

  propagatedBuildInputs = [
    application
    dateutil
    dns
    eventlib
    gevent
    ag-gnutls
    lxml
    msrplib
    otr
    twisted
    xcaplib
  ];

  nativeBuildInputs = [
    cython
    pkg-config
  ];

  buildInputs = [
    openssl
    ffmpeg
    sqlite
    libv4l
    libopus
    alsaLib
    opencore-amr
    x264
    libvpx
  ];

  disabled = !isPy3k;

  # because a test refers to /etc/protocols
  preCheck = ''
    export NIX_REDIRECTS=/etc/protocols=${iana-etc}/etc/protocols \
      LD_PRELOAD=${libredirect}/lib/libredirect.so
  '';
  postCheck = ''
    unset NIX_REDIRECTS LD_PRELOAD
  '';

  pythonImportsCheck = [ "sipsimple" ];

  meta = with lib; {
    description = "Python SDK for development of SIP end-points";
    homepage = "https://github.com/AGProjects/python3-sipsimple";
    license = licenses.gpl3Plus;
    maintainers = with maintainers; [ chanley ];
    longDescription = ''
      SIP SIMPLE client SDK is a Software Development Kit for easy development
      of SIP end-points that support rich media like Audio, Video, Instant Messaging,
      File Transfers, Desktop Sharing and Presence.  Other media types can be
      easily added by using an extensible high-level API.

      The software has undergone in the past years several interoperability tests
      at SIPIT (http://www.sipit.net) and today is of industry strength quality.

    '';
  };
}
