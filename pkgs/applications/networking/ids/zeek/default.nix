{ lib
, stdenv
, callPackage
, fetchurl
, cmake
, flex
, bison
, spicy-parser-generator
, openssl
, libkqueue
, libpcap
, zlib
, file
, curl
, libmaxminddb
, gperftools
, python3
, swig
, gettext
, coreutils
, ncurses
}:

let
  broker = callPackage ./broker { };
in
stdenv.mkDerivation rec {
  pname = "zeek";
  version = "5.2.2";

  src = fetchurl {
    url = "https://download.zeek.org/zeek-${version}.tar.gz";
    sha256 = "sha256-4MJBV8yWpy5LvkyyipOZdDjU6FV7F8INc/zWddRGFcY=";
  };

  strictDeps = true;

  patches = [
    ./avoid-broken-tests.patch
    ./debug-runtime-undef-fortify-source.patch
    ./fix-installation.patch
  ];

  nativeBuildInputs = [
    bison
    cmake
    file
    flex
    python3
  ];

  buildInputs = [
    broker
    spicy-parser-generator
    curl
    gperftools
    libmaxminddb
    libpcap
    ncurses
    openssl
    swig
    zlib
  ] ++ lib.optionals stdenv.isLinux [
    libkqueue
  ] ++ lib.optionals stdenv.isDarwin [
    gettext
  ];

  postPatch = ''
    patchShebangs ./auxil/spicy/spicy/scripts

    substituteInPlace auxil/spicy/CMakeLists.txt --replace "hilti-toolchain-tests" ""
    substituteInPlace auxil/spicy/spicy/hilti/CMakeLists.txt --replace "hilti-toolchain-tests" ""
  '';

  cmakeFlags = [
    "-DBroker_ROOT=${broker}"
    "-DSPICY_ROOT_DIR=${spicy-parser-generator}"
    "-DENABLE_PERFTOOLS=true"
    "-DINSTALL_AUX_TOOLS=true"
    "-DZEEK_ETC_INSTALL_DIR=/etc/zeek"
    "-DZEEK_LOG_DIR=/var/log/zeek"
    "-DZEEK_STATE_DIR=/var/lib/zeek"
    "-DZEEK_SPOOL_DIR=/var/spool/zeek"
  ] ++ lib.optionals stdenv.isLinux [
    "-DLIBKQUEUE_ROOT_DIR=${libkqueue}"
  ];

  postInstall = ''
    for file in $out/share/zeek/base/frameworks/notice/actions/pp-alarms.zeek $out/share/zeek/base/frameworks/notice/main.zeek; do
      substituteInPlace $file \
         --replace "/bin/rm" "${coreutils}/bin/rm" \
         --replace "/bin/cat" "${coreutils}/bin/cat"
    done

    for file in $out/share/zeek/policy/misc/trim-trace-file.zeek $out/share/zeek/base/frameworks/logging/postprocessors/scp.zeek $out/share/zeek/base/frameworks/logging/postprocessors/sftp.zeek; do
      substituteInPlace $file --replace "/bin/rm" "${coreutils}/bin/rm"
    done
  '';

  passthru = {
    inherit broker;
  };

  meta = with lib; {
    description = "Network analysis framework much different from a typical IDS";
    homepage = "https://www.zeek.org";
    changelog = "https://github.com/zeek/zeek/blob/v${version}/CHANGES";
    license = licenses.bsd3;
    maintainers = with maintainers; [ pSub marsam tobim ];
    platforms = platforms.unix;
  };
}
