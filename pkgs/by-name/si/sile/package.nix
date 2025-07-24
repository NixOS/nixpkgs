{
  lib,
  stdenv,
  fetchurl,

  # nativeBuildInputs
  zstd,
  pkg-config,
  jq,
  cargo,
  rustc,
  rustPlatform,
  luarocks,

  # buildInputs
  lua,
  harfbuzz,
  icu,
  fontconfig,
  libiconv,
  # FONTCONFIG_FILE
  makeFontsConf,
  gentium-plus,

  # passthru.tests
  runCommand,
  poppler-utils,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "sile";
  version = "0.15.13";

  src = fetchurl {
    url = "https://github.com/sile-typesetter/sile/releases/download/v${finalAttrs.version}/sile-${finalAttrs.version}.tar.zst";
    hash = "sha256-XpfBllGv9xBoe5MpLVNhy0EWUglLzIxiyBHBn3qBRks=";
  };

  cargoDeps = rustPlatform.fetchCargoVendor {
    inherit (finalAttrs) pname version src;
    dontConfigure = true;
    nativeBuildInputs = [ zstd ];
    hash = "sha256-phRnyaF8KTYlgrgBeVNPxBAokRBUoj9vs7P9y97wbG8=";
  };

  nativeBuildInputs = [
    zstd
    pkg-config
    fontconfig # fc-match
    jq
    cargo
    rustc
    rustPlatform.cargoSetupHook
    luarocks
  ];
  # luarocks propagates cmake, but it shouldn't be used as a build system.
  dontUseCmakeConfigure = true;

  buildInputs = [
    finalAttrs.finalPackage.passthru.luaEnv
    harfbuzz
    icu
    fontconfig
    libiconv
  ];

  configureFlags = [
    # Nix will supply all the Lua dependencies, so stop the build system from
    # bundling vendored copies of them.
    "--with-system-lua-sources"
    "--with-system-luarocks"
    # The automake check target uses pdfinfo to confirm the output of a test
    # run, and uses autotools to discover it. This flake build eschews that
    # test because it is run from the source directory but the binary is
    # already built with system paths, so it can't be checked under Nix until
    # after install. After install the Makefile isn't available of course, so
    # we have our own copy of it with a hard coded path to `pdfinfo`. By
    # specifying some binary here we skip the configure time test for
    # `pdfinfo`, by using `false` we make sure that if it is expected during
    # build time we would fail to build since we only provide it at test time.
    "PDFINFO=false"
  ]
  ++ lib.optionals (!lua.pkgs.isLuaJIT) [
    "--without-luajit"
  ];

  outputs = [
    "out"
    "doc"
    "man"
    "dev"
  ];

  # TODO: At some point, upstream should support installing the pre-built
  # manual automatically
  postInstall = ''
    install -Dm0644 documentation/sile.pdf $out/share/doc/sile/manual.pdf
  '';

  FONTCONFIG_FILE = makeFontsConf {
    fontDirectories = [
      gentium-plus
    ];
  };
  strictDeps = true;
  env.LUA = "${finalAttrs.finalPackage.passthru.luaEnv}/bin/lua";

  enableParallelBuilding = true;

  passthru = {
    # Use this passthru variable to add packages to your lua environment. Use
    # something like this in your development environment:
    #
    # myLuaEnv = lua.withPackages (
    #  ps: lib.attrVals (sile.passthru.luaPackages ++ [
    #    "lua-cjson"
    #    "lua-resty-http"
    #  ]) ps
    # )
    luaPackages = [
      "cassowary"
      "cldr"
      "fluent"
      "linenoise"
      "loadkit"
      "lpeg"
      "lua-zlib"
      "lua_cliargs"
      "luaepnf"
      "luaexpat"
      "luafilesystem"
      "luarepl"
      "luasec"
      "luasocket"
      "luautf8"
      "penlight"
      "vstruct"
      # lua packages needed for testing
      "busted"
      "luacheck"
      # packages needed for building api docs
      "ldoc"
      # NOTE: Add lua packages here, to change the luaEnv also read by `flake.nix`
    ]
    ++ lib.optionals (lib.versionOlder lua.luaversion "5.2") [
      "bit32"
    ]
    ++ lib.optionals (lib.versionOlder lua.luaversion "5.3") [
      "compat53"
    ];
    luaEnv = lua.withPackages (ps: lib.attrVals finalAttrs.finalPackage.passthru.luaPackages ps);

    # Copied from Makefile.am
    tests.test = lib.optionalAttrs (!(stdenv.hostPlatform.isDarwin && stdenv.hostPlatform.isAarch64)) (
      runCommand "${finalAttrs.pname}-test"
        {
          nativeBuildInputs = [
            poppler-utils
            finalAttrs.finalPackage
          ];
          inherit (finalAttrs) FONTCONFIG_FILE;
        }
        ''
          output=$(mktemp -t selfcheck-XXXXXX.pdf)
          echo "<sile>foo</sile>" | sile -o $output -
          pdfinfo $output | grep "SILE v${finalAttrs.version}" > $out
        ''
    );
  };

  meta = {
    description = "Typesetting system";
    longDescription = ''
      SILE is a typesetting system; its job is to produce beautiful
      printed documents. Conceptually, SILE is similar to TeX—from
      which it borrows some concepts and even syntax and
      algorithms—but the similarities end there. Rather than being a
      derivative of the TeX family SILE is a new typesetting and
      layout engine written from the ground up using modern
      technologies and borrowing some ideas from graphical systems
      such as InDesign.
    '';
    homepage = "https://sile-typesetter.org";
    changelog = "https://github.com/sile-typesetter/sile/raw/v${finalAttrs.version}/CHANGELOG.md";
    platforms = lib.platforms.unix;
    maintainers = with lib.maintainers; [
      doronbehar
      alerque
    ];
    license = lib.licenses.mit;
    mainProgram = "sile";
  };
})
