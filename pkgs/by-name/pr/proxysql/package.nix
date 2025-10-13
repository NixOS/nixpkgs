{
  stdenv,
  lib,
  applyPatches,
  fetchFromGitHub,
  autoconf,
  automake,
  bison,
  cmake,
  pkg-config,
  libtool,
  civetweb,
  coreutils,
  curl,
  flex,
  gnutls,
  libconfig,
  libdaemon,
  libev,
  libgcrypt,
  libinjection,
  libmicrohttpd,
  libuuid,
  lz4,
  nlohmann_json,
  openssl,
  pcre,
  perl,
  python3,
  prometheus-cpp,
  zlib,
  texinfo,
  postgresql_16,
  icu,
  libevent,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "proxysql";
  version = "3.0.1";

  src = fetchFromGitHub {
    owner = "sysown";
    repo = "proxysql";
    tag = "v${finalAttrs.version}";
    hash = "sha256-yGxn46Vm8YdtIvvoTlOHQ1aAP2J/h/kFqr4ehruDsTw=";
  };

  patches = [
    ./makefiles.patch
    ./dont-phone-home.patch
  ];

  nativeBuildInputs = [
    autoconf
    automake
    cmake
    libtool
    perl
    pkg-config
    python3
    texinfo # for makeinfo
  ];

  buildInputs = [
    bison
    curl
    flex
    gnutls
    icu
    libevent
    libgcrypt
    libuuid
    openssl
    zlib
  ];

  enableParallelBuilding = true;

  GIT_VERSION = finalAttrs.version;

  dontConfigure = true;

  # replace and fix some vendored dependencies
  preBuild = # sh
    ''
      pushd deps

      function replace_dep() {
        local folder="$1"
        local src="$2"
        local symlink="$3"
        local name="$4"

        pushd "$folder"

        rm -rf "$symlink"
        if [ -d "$src" ]; then
          cp -R "$src"/. "$symlink"
          chmod -R u+w "$symlink"
        else
          tar xf "$src"
          ln -s "$name" "$symlink"
        fi

        popd
      }

      ${lib.concatMapStringsSep "\n"
        (
          x:
          ''replace_dep "${x.f}" "${x.p.src}" "${
            x.p.pname or (builtins.parseDrvName x.p.name).name
          }" "${x.p.name}"''
        )
        (
          map
            (x: {
              inherit (x) f;
              p = x.p // {
                src = applyPatches {
                  inherit (x.p) src patches;
                };
              };
            })
            [
              {
                f = "curl";
                p = curl;
              }
              {
                f = "libconfig";
                p = libconfig;
              }
              {
                f = "libdaemon";
                p = libdaemon;
              }
              {
                f = "libev";
                p = libev;
              }
              {
                f = "libinjection";
                p = libinjection;
              }
              {
                f = "libmicrohttpd";
                p = libmicrohttpd;
              }
              {
                f = "lz4";
                p = lz4;
              }
              {
                f = "pcre";
                p = pcre;
              }
              {
                f = "prometheus-cpp";
                p = prometheus-cpp.overrideAttrs (
                  finalAttrs: _: {
                    version = "1.1.0";

                    src = fetchFromGitHub {
                      owner = "jupp0r";
                      repo = "prometheus-cpp";
                      tag = "v${finalAttrs.version}";
                      hash = "sha256-qx6oBxd0YrUyFq+7ArnKBqOwrl5X8RS9nErhRDUJ7+8=";
                    };
                  }
                );
              }
              {
                f = "postgresql";
                p = postgresql_16;
              }
            ]
        )
      }

      pushd libhttpserver
      tar xf libhttpserver-*.tar.gz
      sed -i s_/bin/pwd_${coreutils}/bin/pwd_g libhttpserver/configure.ac
      popd

      pushd json
      rm json.hpp
      ln -s ${nlohmann_json.src}/single_include/nlohmann/json.hpp .
      popd

      pushd prometheus-cpp/prometheus-cpp/3rdparty
      replace_dep . "${civetweb.src}" civetweb
      popd

      pushd libmicrohttpd/libmicrohttpd
      autoreconf
      popd

      pushd libconfig/libconfig
      autoreconf
      popd

      pushd libdaemon/libdaemon
      autoreconf
      popd

      pushd pcre/pcre
      autoreconf
      popd

      popd
      patchShebangs .
    '';

  preInstall = ''
    mkdir -p $out/{etc,bin,lib/systemd/system}
  '';

  postInstall = ''
    sed -i s_/usr/bin/proxysql_$out/bin/proxysql_ $out/lib/systemd/system/*.service
  '';

  meta = with lib; {
    broken = stdenv.hostPlatform.isDarwin;
    description = "High-performance MySQL proxy";
    mainProgram = "proxysql";
    homepage = "https://proxysql.com/";
    license = with licenses; [ gpl3Only ];
    teams = [ teams.helsinki-systems ];
    platforms = platforms.unix;
  };
})
