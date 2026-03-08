{
  lib,
  stdenv,
  fetchurl,
  fetchpatch,
  # native deps.
  runCommand,
  pkg-config,
  meson,
  ninja,
  makeWrapper,
  # build+runtime deps.
  knot-dns,
  luajitPackages,
  libuv,
  gnutls,
  lmdb,
  # optionals, in principle
  jemalloc,
  systemdMinimal,
  libcap_ng,
  dns-root-data,
  nghttp2,
  ngtcp2-gnutls,
  fstrm,
  protobufc,
  # test-only deps.
  cmocka,
  which,
  cacert,
}:
let
  inherit (lib) optional optionals optionalString;
  lua = luajitPackages;

  # TODO: we could cut the `let` short here, but it would de-indent everything.
  unwrapped = stdenv.mkDerivation (finalAttrs: {
    pname = "knot-resolver_6";
    version = "6.2.0";

    src = fetchurl {
      url = "https://secure.nic.cz/files/knot-resolver/knot-resolver-${finalAttrs.version}.tar.xz";
      hash = "sha256-tEYzvIQxgMC8fHfPexX+VxJDrpkrTdt0r97kz6gDcBs=";
    };

    outputs = [
      "out"
      "dev"
      "config_py"
    ];

    patches = [
      # Install-time paths sometimes differ from run-time paths in nixpkgs.
      ./paths.patch
    ];

    # systemd Exec* options are difficult to override in NixOS *if present*, so we drop them.
    postPatch = ''
      sed -e '/^ExecStart=/d' -e '/^ExecReload=/d' \
        -i systemd/knot-resolver.service.in
    ''
    # some tests have issues with network sandboxing, apparently
    + optionalString finalAttrs.doInstallCheck ''
      echo 'os.exit(77)' > daemon/lua/trust_anchors.test/bootstrap.test.lua
      sed -E '/^[[:blank:]]*test_(dstaddr|headers),?$/d' -i \
        tests/config/doh2.test.lua modules/http/http_doh.test.lua
    '';

    preConfigure = ''
      patchShebangs scripts/
    '';

    nativeBuildInputs = [
      pkg-config
      meson
      ninja
      protobufc
    ];

    # http://knot-resolver.readthedocs.io/en/latest/build.html#requirements
    buildInputs = [
      knot-dns
      lua.lua
      libuv
      gnutls
      lmdb
    ]
    ## the rest are optional dependencies
    ++ optionals stdenv.hostPlatform.isLinux [
      # lib
      systemdMinimal
      libcap_ng
    ]
    ++ [
      jemalloc
      nghttp2
      ngtcp2-gnutls
      # dnstap support
      fstrm
      protobufc
    ];

    mesonFlags = [
      "-Dkeyfile_default=${dns-root-data}/root.ds"
      "-Droot_hints=${dns-root-data}/root.hints"
      "-Dinstall_kresd_conf=disabled" # not really useful; examples are inside share/doc/
      "-Dmalloc=jemalloc"
      "--default-library=static" # not used by anyone
    ]
    ++ optional finalAttrs.doInstallCheck "-Dunit_tests=enabled"
    ++ optional finalAttrs.doInstallCheck "-Dconfig_tests=enabled"
    ++ optional stdenv.hostPlatform.isLinux "-Dsystemd_files=enabled" # used by NixOS service
    #"-Dextra_tests=enabled" # not suitable as in-distro tests; many deps, too.
    ;

    postInstall = ''
      cp -r ./python "$config_py"
      rm "$out"/lib/libkres.a
    ''
    + optionalString stdenv.hostPlatform.isLinux ''
      rm -r "$out"/lib/sysusers.d/ # ATM more likely to harm than help
    '';

    doInstallCheck = with stdenv; hostPlatform == buildPlatform;
    nativeInstallCheckInputs = [
      which
      cacert
      lua.cqueues
      lua.basexx
      lua.http
    ];
    installCheckInputs = [
      cmocka
    ];
    installCheckPhase = ''
      meson test --print-errorlogs --no-suite snowflake
    '';

    strictDeps = true;

    passthru = {
      inherit lua;
      inherit (finalAttrs) finalPackage;
    };

    meta = {
      description = "Caching validating DNS resolver, from .cz domain registry";
      homepage = "https://knot-resolver.cz";
      license = lib.licenses.gpl3Plus;
      platforms = lib.platforms.unix;
      maintainers = [
        lib.maintainers.vcunat # upstream developer
        lib.maintainers.leona
        lib.maintainers.osnyx
      ];
      mainProgram = "kresd";
    };
  });

in
unwrapped
