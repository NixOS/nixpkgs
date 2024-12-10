{
  lib,
  stdenv,
  callPackage,
  fetchurl,
  cmake,
  flex,
  bison,
  openssl,
  libkqueue,
  libpcap,
  zlib,
  file,
  curl,
  libmaxminddb,
  gperftools,
  python3,
  swig,
  gettext,
  coreutils,
  ncurses,
}:

let
  broker = callPackage ./broker { };
  python = python3.withPackages (p: [
    p.gitpython
    p.semantic-version
  ]);
in
stdenv.mkDerivation rec {
  pname = "zeek";
  version = "6.2.1";

  src = fetchurl {
    url = "https://download.zeek.org/zeek-${version}.tar.gz";
    hash = "sha256-ZOOlK9mfZVrfxvgFREgqcRcSs18EMpADD8Y4Ev391Bw=";
  };

  strictDeps = true;

  patches = [
    ./fix-installation.patch
  ];

  nativeBuildInputs = [
    bison
    cmake
    file
    flex
    python
  ];

  buildInputs =
    [
      broker
      curl
      gperftools
      libmaxminddb
      libpcap
      ncurses
      openssl
      swig
      zlib
      python
    ]
    ++ lib.optionals stdenv.isLinux [
      libkqueue
    ]
    ++ lib.optionals stdenv.isDarwin [
      gettext
    ];

  postPatch = ''
    patchShebangs ./ci/collect-repo-info.py
    patchShebangs ./auxil/spicy/scripts
  '';

  cmakeFlags =
    [
      "-DBroker_ROOT=${broker}"
      "-DENABLE_PERFTOOLS=true"
      "-DINSTALL_AUX_TOOLS=true"
      "-DZEEK_ETC_INSTALL_DIR=/etc/zeek"
      "-DZEEK_LOG_DIR=/var/log/zeek"
      "-DZEEK_STATE_DIR=/var/lib/zeek"
      "-DZEEK_SPOOL_DIR=/var/spool/zeek"
      "-DDISABLE_JAVASCRIPT=ON"
    ]
    ++ lib.optionals stdenv.isLinux [
      "-DLIBKQUEUE_ROOT_DIR=${libkqueue}"
    ];

  env.NIX_CFLAGS_COMPILE = lib.optionalString stdenv.isDarwin "-faligned-allocation";

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
    maintainers = with maintainers; [
      pSub
      tobim
    ];
    platforms = platforms.unix;
  };
}
