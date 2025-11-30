{
  lib,
  stdenv,
  fetchFromGitHub,

  # nativeBuildInputs
  ninja,
  makeWrapper,

  # buildInputs
  fmt,
  rsync,

  versionCheckHook,
  nix-update-script,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "lua-language-server";
  version = "3.15.0";

  src = fetchFromGitHub {
    owner = "luals";
    repo = "lua-language-server";
    tag = finalAttrs.version;
    hash = "sha256-frsq5OA3giLOJ/KPcAqVhme+0CtJuZrS3F4zHN1PnFM=";
    fetchSubmodules = true;
  };

  nativeBuildInputs = [
    ninja
    makeWrapper
  ];

  buildInputs = [
    fmt
  ]
  ++ lib.optionals stdenv.hostPlatform.isDarwin [
    rsync
  ];

  env.NIX_LDFLAGS = "-lfmt";

  postPatch = ''
    # filewatch tests are failing on darwin
    # this feature is not used in lua-language-server
    substituteInPlace 3rd/bee.lua/test/test.lua \
      --replace-fail 'require "test_filewatch"' ""

    # use nixpkgs fmt library
    for d in 3rd/bee.lua 3rd/luamake/bee.lua
    do
      rm -r $d/3rd/fmt/*
      touch $d/3rd/fmt/format.cc
      substituteInPlace $d/bee/nonstd/format.h $d/bee/nonstd/print.h \
        --replace-fail "include <3rd/fmt/fmt" "include <fmt"
    done

    # flaky tests on linux
    # https://github.com/LuaLS/lua-language-server/issues/2926
    substituteInPlace test/tclient/init.lua \
      --replace-fail "require 'tclient.tests.load-relative-library'" ""

    pushd 3rd/luamake
  ''
  + lib.optionalString stdenv.hostPlatform.isDarwin (
    # This package uses the program clang for C and C++ files. The language
    # is selected via the command line argument -std, but this do not work
    # in combination with the nixpkgs clang wrapper. Therefor we have to
    # find all c++ compiler statements and replace $cc (which expands to
    # clang) with clang++.
    ''
      sed -i compile/ninja/macos.ninja \
        -e '/c++/s,$cc,clang++,' \
        -e '/test.lua/s,= .*,= true,' \
        -e '/ldl/s,$cc,clang++,'
      sed -i scripts/compiler/gcc.lua \
        -e '/cxx_/s,$cc,clang++,'
    ''
    # Avoid relying on ditto (impure)
    + ''
      substituteInPlace compile/ninja/macos.ninja \
        --replace-fail "ditto" "rsync -a"

      substituteInPlace scripts/writer.lua \
        --replace-fail "ditto" "rsync -a"
    ''
  );

  ninjaFlags = [
    "-fcompile/ninja/${if stdenv.hostPlatform.isDarwin then "macos" else "linux"}.ninja"
  ];

  postBuild = ''
    popd
    ./3rd/luamake/luamake rebuild
  '';

  installPhase = ''
    runHook preInstall

    install -Dt "$out"/share/lua-language-server/bin bin/lua-language-server
    install -m644 -t "$out"/share/lua-language-server/bin bin/*.*
    install -m644 -t "$out"/share/lua-language-server {debugger,main}.lua
    cp -r locale meta script "$out"/share/lua-language-server

    # necessary for --version to work:
    install -m644 -t "$out"/share/lua-language-server changelog.md

    makeWrapper "$out"/share/lua-language-server/bin/lua-language-server \
      $out/bin/lua-language-server \
      --add-flags "-E $out/share/lua-language-server/main.lua \
      --logpath=\''${XDG_CACHE_HOME:-\$HOME/.cache}/lua-language-server/log \
      --metapath=\''${XDG_CACHE_HOME:-\$HOME/.cache}/lua-language-server/meta"

    runHook postInstall
  '';

  # some tests require local networking
  __darwinAllowLocalNetworking = true;

  nativeInstallCheckInputs = [
    versionCheckHook
  ];
  versionCheckProgramArg = "--version";
  doInstallCheck = true;

  passthru.updateScript = nix-update-script { };

  meta = {
    description = "Language server that offers Lua language support";
    homepage = "https://github.com/luals/lua-language-server";
    changelog = "https://github.com/LuaLS/lua-language-server/blob/${finalAttrs.version}/changelog.md";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [
      gepbird
      sei40kr
    ];
    mainProgram = "lua-language-server";
    platforms = lib.platforms.linux ++ lib.platforms.darwin;
  };
})
