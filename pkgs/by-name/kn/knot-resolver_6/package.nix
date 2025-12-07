{
  lib,
  stdenv,
  fetchurl,
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
  jemalloc,
  systemdMinimal,
  libcap_ng,
  dns-root-data,
  nghttp2, # optionals, in principle
  fstrm,
  protobufc, # more optionals
  # test-only deps.
  cmocka,
  which,
  cacert,
  extraFeatures ? false, # catch-all if defaults aren't enough
}:
let
  result = if extraFeatures then wrapped-full else unwrapped;

  inherit (lib) optional optionals optionalString;
  lua = luajitPackages;

  unwrapped = stdenv.mkDerivation (finalAttrs: {
    pname = "knot-resolver_6";
    version = "6.0.17";

    src = fetchurl {
      url = "https://secure.nic.cz/files/knot-resolver/knot-resolver-${finalAttrs.version}.tar.xz";
      hash = "sha256-E9RJbvh66y+9OwBX4iEdRYUgUkHlCaDNQ0Hb5ejLXBw=";
    };

    outputs = [
      "out"
      "dev"
      "config_py"
    ];

    # Path fixups for the NixOS service.
    # systemd Exec* options are difficult to override in NixOS *if present*, so we drop them.
    postPatch = ''
      patch meson.build <<EOF
      @@ -50,2 +50,3 @@
      -systemd_work_dir = prefix / get_option('localstatedir') / 'lib' / 'knot-resolver'
      -systemd_cache_dir = prefix / get_option('localstatedir') / 'cache' / 'knot-resolver'
      +systemd_work_dir  = '/var/lib/knot-resolver'
      +systemd_cache_dir = '/var/cache/knot-resolver'
      +run_dir = '/run/knot-resolver'
      EOF

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
      cmocka
      which
      cacert
      lua.cqueues
      lua.basexx
      lua.http
    ];
    installCheckPhase = ''
      meson test --print-errorlogs --no-suite snowflake
    '';

    passthru = {
      unwrapped = finalAttrs.finalPackage;
    };

    meta = with lib; {
      description = "Caching validating DNS resolver, from .cz domain registry";
      homepage = "https://knot-resolver.cz";
      license = licenses.gpl3Plus;
      platforms = platforms.unix;
      maintainers = [
        maintainers.vcunat # upstream developer
      ];
      teams = [ teams.flyingcircus ];
      mainProgram = "kresd";
    };
  });

  wrapped-full =
    runCommand unwrapped.name
      {
        nativeBuildInputs = [ makeWrapper ];
        buildInputs = with luajitPackages; [
          # For http module, prefill module, trust anchor bootstrap.
          # It brings lots of deps; some are useful elsewhere (e.g. cqueues).
          http
          # used by policy.slice_randomize_psl()
          psl
        ];
        preferLocalBuild = true;
        allowSubstitutes = false;
        inherit (unwrapped) version meta;
        passthru = {
          inherit unwrapped;
        };
      }
      (
        ''
          mkdir -p "$out"/bin
          makeWrapper '${unwrapped}/bin/kresd' "$out"/bin/kresd \
            --set LUA_PATH  "$LUA_PATH" \
            --set LUA_CPATH "$LUA_CPATH"

          ln -sr '${unwrapped}/bin/kres-cache-gc' "$out"/bin/
          ln -sr '${unwrapped}/share' "$out"/
          ln -sr '${unwrapped}/lib'   "$out"/ # useful in NixOS service
          ln -sr "$out"/{bin,sbin}
        ''
        + lib.optionalString unwrapped.doInstallCheck ''
          echo "Checking that 'http' module loads, i.e. lua search paths work:"
          echo "modules.load('http')" > test-http.lua
          echo -e 'quit()' | env -i "$out"/bin/kresd -a 127.0.0.1#53535 -c test-http.lua
        ''
      );

in
result
