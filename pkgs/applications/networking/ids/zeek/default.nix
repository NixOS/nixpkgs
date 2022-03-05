{ lib
, stdenv
, fetchurl
, cmake
, flex
, bison
, openssl
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
, caf
}:

stdenv.mkDerivation rec {
  pname = "zeek";
  version = "4.2.0";

  src = fetchurl {
    url = "https://download.zeek.org/zeek-${version}.tar.gz";
    sha256 = "sha256-jZoCjKn+x61KnkinY+KWBSOEz0AupM03FXe/8YPCdFE=";
  };

  nativeBuildInputs = [
    bison
    cmake
    file
    flex
  ];

  buildInputs = [
    curl
    gperftools
    libmaxminddb
    libpcap
    ncurses
    openssl
    python3
    swig
    zlib
  ] ++ lib.optionals stdenv.isDarwin [
    gettext
  ];

  outputs = [ "out" "lib" "py" ];

  cmakeFlags = [
    "-DCAF_ROOT=${caf}"
    "-DZEEK_PYTHON_DIR=${placeholder "py"}/lib/${python3.libPrefix}/site-packages"
    "-DENABLE_PERFTOOLS=true"
    "-DINSTALL_AUX_TOOLS=true"
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

  meta = with lib; {
    description = "Network analysis framework much different from a typical IDS";
    homepage = "https://www.zeek.org";
    changelog = "https://github.com/zeek/zeek/blob/v${version}/CHANGES";
    license = licenses.bsd3;
    maintainers = with maintainers; [ pSub marsam tobim ];
    platforms = platforms.unix;
  };
}
