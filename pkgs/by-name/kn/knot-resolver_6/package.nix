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
}:
let
  inherit (lib) optional optionals optionalString;
  lua = luajitPackages;

  # TODO: we could cut the `let` short here, but it would de-indent everything.
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

    patches = [
      (fetchpatch {
        name = "test-cache-aarch64-darwin.patch";
        url = "https://gitlab.nic.cz/knot/knot-resolver/-/commit/d155d0dbe408a3327b39f70e122aea6fb2b86684.diff";
        excludes = [ "NEWS" ];
        hash = "sha256-3w33v8UfhGdA50BlkfHpQLFxg+5ELk0lp7RzgvkSzK8=";
      })
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
      ];
      teams = [ lib.teams.flyingcircus ];
      mainProgram = "kresd";
    };
  });

in
unwrapped
