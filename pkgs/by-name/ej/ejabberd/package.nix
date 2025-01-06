{
  stdenv,
  makeWrapper,
  lib,
  libpng,
  libjpeg,
  libwebp,
  erlang,
  openssl,
  expat,
  libyaml,
  bash,
  gnused,
  gnugrep,
  coreutils,
  util-linux,
  procps,
  gd,
  autoreconfHook,
  gawk,
  rebar3WithPlugins,
  fetchFromGitHub,
  fetchgit,
  fetchHex,
  beamPackages,
  nixosTests,
  withMysql ? false,
  withPgsql ? false,
  withSqlite ? false,
  sqlite,
  withPam ? false,
  pam,
  withZlib ? true,
  zlib,
  withSip ? false,
  withLua ? false,
  withTools ? false,
  withRedis ? false,
  withImagemagick ? false,
  imagemagick,
}:

let
  ctlpath = lib.makeBinPath [
    bash
    gnused
    gnugrep
    gawk
    coreutils
    util-linux
    procps
  ];

  provider_asn1 = beamPackages.buildRebar3 {
    name = "provider_asn1";
    version = "0.3.0";
    src = fetchHex {
      pkg = "provider_asn1";
      version = "0.3.0";
      sha256 = "sha256-MuelWYZi01rBut8jM6a5alMZizPGZoBE/LveSRu/+wU=";
    };
    beamDeps = [ ];
  };
  rebar3_hex = beamPackages.buildRebar3 {
    name = "rebar3_hex";
    version = "7.0.7";
    src = fetchHex {
      pkg = "rebar3_hex";
      version = "7.0.7";
      sha256 = "sha256-1S2igSwiInATUgULZ1E6e2dK6YI5gvRffHRfF1Gg5Ok=";
    };
    beamDeps = [ ];
  };

  allBeamDeps = import ./rebar-deps.nix {
    # TODO(@chuangzhu) add updateScript
    inherit fetchHex fetchgit fetchFromGitHub;
    builder = lib.makeOverridable beamPackages.buildRebar3;

    overrides = final: prev: {
      jiffy = prev.jiffy.override { buildPlugins = [ beamPackages.pc ]; };
      cache_tab = prev.cache_tab.override { buildPlugins = [ beamPackages.pc ]; };
      mqtree = prev.mqtree.override { buildPlugins = [ beamPackages.pc ]; };
      stringprep = prev.stringprep.override { buildPlugins = [ beamPackages.pc ]; };
      p1_acme = prev.p1_acme.override { buildPlugins = [ beamPackages.pc ]; };
      eimp = prev.eimp.override {
        buildInputs = [
          gd
          libwebp
          libpng
          libjpeg
        ];
        buildPlugins = [ beamPackages.pc ];
      };
      fast_tls = prev.fast_tls.override {
        buildInputs = [ openssl ];
        buildPlugins = [ beamPackages.pc ];
      };
      fast_xml = prev.fast_xml.override {
        buildInputs = [ expat ];
        buildPlugins = [ beamPackages.pc ];
      };
      fast_yaml = prev.fast_yaml.override {
        buildInputs = [ libyaml ];
        buildPlugins = [ beamPackages.pc ];
      };
      xmpp = prev.xmpp.override {
        buildPlugins = [
          beamPackages.pc
          provider_asn1
        ];
      };
      # Optional deps
      sqlite3 = prev.sqlite3.override {
        buildInputs = [ sqlite ];
        buildPlugins = [ beamPackages.pc ];
      };
      p1_mysql = prev.p1_acme.override { buildPlugins = [ beamPackages.pc ]; };
      epam = prev.epam.override {
        buildInputs = [ pam ];
        buildPlugins = [ beamPackages.pc ];
      };
      esip = prev.esip.override { buildPlugins = [ beamPackages.pc ]; };
      ezlib = prev.ezlib.override {
        buildInputs = [ zlib ];
        buildPlugins = [ beamPackages.pc ];
      };
    };
  };

  beamDeps = builtins.removeAttrs allBeamDeps [
    "sqlite3"
    "p1_pgsql"
    "p1_mysql"
    "luerl"
    "esip"
    "eredis"
    "epam"
    "ezlib"
  ];

in
stdenv.mkDerivation (finalAttrs:{
  pname = "ejabberd";
  version = "24.07";

  nativeBuildInputs = [
    makeWrapper
    autoreconfHook
    (rebar3WithPlugins {
      plugins = [
        provider_asn1
        rebar3_hex
      ];
    })
  ];

  buildInputs =
    [ erlang ]
    ++ builtins.attrValues beamDeps
    ++ lib.optional withMysql allBeamDeps.p1_mysql
    ++ lib.optional withPgsql allBeamDeps.p1_pgsql
    ++ lib.optional withSqlite allBeamDeps.sqlite3
    ++ lib.optional withPam allBeamDeps.epam
    ++ lib.optional withZlib allBeamDeps.ezlib
    ++ lib.optional withSip allBeamDeps.esip
    ++ lib.optional withLua allBeamDeps.luerl
    ++ lib.optional withRedis allBeamDeps.eredis;

  src = fetchFromGitHub {
    owner = "processone";
    repo = "ejabberd";
    rev = "refs/tags/${finalAttrs.version}";
    hash = "sha256-4wEQBumWrHqN2uNrDxAJhgv2ok7pgQlAEPpL96ZOsTQ=";
  };

  passthru.tests = {
    inherit (nixosTests) ejabberd;
  };

  configureFlags = [
    (lib.enableFeature withMysql "mysql")
    (lib.enableFeature withPgsql "pgsql")
    (lib.enableFeature withSqlite "sqlite")
    (lib.enableFeature withPam "pam")
    (lib.enableFeature withZlib "zlib")
    (lib.enableFeature withSip "sip")
    (lib.enableFeature withLua "lua")
    (lib.enableFeature withTools "tools")
    (lib.enableFeature withRedis "redis")
  ] ++ lib.optional withSqlite "--with-sqlite3=${sqlite.dev}";

  enableParallelBuilding = true;

  postPatch = ''
    patchShebangs .
    mkdir -p _build/default/lib
    touch _build/default/lib/.got
    touch _build/default/lib/.built
  '';

  REBAR_IGNORE_DEPS = 1;

  postInstall = ''
    sed -i \
      -e '2iexport PATH=${ctlpath}:$PATH' \
      -e "s,\(^ *ERL_LIBS=.*\),\1:$ERL_LIBS," \
      $out/sbin/ejabberdctl
    ${lib.optionalString withImagemagick ''wrapProgram $out/lib/ejabberd-*/priv/bin/captcha.sh --prefix PATH : "${
      lib.makeBinPath [ imagemagick ]
    }"''}
  '';

  meta = {
    description = "Open-source XMPP application server written in Erlang";
    mainProgram = "ejabberdctl";
    license = lib.licenses.gpl2Plus;
    homepage = "https://www.ejabberd.im";
    platforms = lib.platforms.linux;
    maintainers = with lib.maintainers; [
      sander
      abbradar
      chuangzhu
    ];
  };
})
