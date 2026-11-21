{
  lib,
  stdenv,
  callPackage,
  cctools,
  fetchFromGitHub,
  fixDarwinDylibNames,
  gitMinimal,
  ncurses,
  pkg-config,
  xcbuild,
  zig_0_17,

  testers,
  runCommand,
  nixfmt,

  optimize ? "ReleaseFast",
  simd ? true,
}:
stdenv.mkDerivation (finalAttrs: {
  pname = "libghostty-vt";
  version = "1.0.1";

  src = fetchFromGitHub {
    owner = "ghostty-org";
    repo = "ghostty";
    tag = "vt-${finalAttrs.version}";
    hash = "sha256-3XBFm8yq25P9eCdjLWwVwZ0tedWCN39U1FbjYD8C+w4=";
  };

  # ./deps.nix is "${finalAttrs.src}/deps/packages.nix"
  deps = callPackage ./deps.nix {
    name = "${finalAttrs.pname}-cache-${finalAttrs.version}";
  };

  __structuredAttrs = true;
  strictDeps = true;

  nativeBuildInputs = [
    gitMinimal
    ncurses
    pkg-config
    zig_0_17
  ]
  ++ lib.optionals stdenv.hostPlatform.isDarwin [
    cctools
    fixDarwinDylibNames
    xcbuild
  ];

  buildInputs = [ ];

  postPatch = lib.optionalString stdenv.hostPlatform.isDarwin ''
    substituteInPlace src/build/LibtoolStep.zig \
      --replace-fail /bin/cp cp \
      --replace-fail /usr/bin/ranlib ranlib
    substituteInPlace src/build/GhosttyLibVt.zig \
      --replace-fail /bin/ln ln
    substituteInPlace pkg/apple-sdk/native_link.zig \
      --replace-fail /usr/bin/xcrun xcrun
  '';

  dontSetZigDefaultFlags = true;

  zigBuildFlags = [
    "--system"
    "${finalAttrs.deps}"
    "-Dlib-version-string=${finalAttrs.version}"
    "-Dcpu=baseline"
    "-Doptimize=${optimize}"
    "-Dapp-runtime=none"
    "-Demit-lib-vt=true"
    "-Dsimd=${lib.boolToString simd}"
  ]
  ++ lib.optionals stdenv.hostPlatform.isDarwin [
    "-Demit-xcframework=false"
  ];

  doCheck = false;

  outputs = [
    "out"
    "dev"
  ];

  postInstall = ''
    mkdir -p "$dev/lib"
    mv "$out/lib/libghostty-vt.a" "$dev/lib/"
  '';

  postFixup = ''
    substituteInPlace "$dev/lib/pkgconfig/libghostty-vt-static.pc" \
      --replace-fail "$out" "$dev"
    substituteInPlace "$dev/lib/cmake/ghostty-vt/ghostty-vt-config.cmake" \
      --replace-fail \
      'set(_ghostty_vt_shared_libdir "''${_ghostty_vt_libdir}")' \
      'set(_ghostty_vt_shared_libdir "${placeholder "out"}/lib/")'
  '';

  passthru = {
    tests = {
      deps = testers.testEqualContents {
        assertion = "vendored lockfile matches upstream lockfile";
        actual = ./deps.nix;
        expected = runCommand "${finalAttrs.pname}-formatted-deps/packages.nix-${finalAttrs.version}" {
          nativeBuildInputs = [ nixfmt ];
        } "nixfmt - < ${finalAttrs.src}/deps/packages.nix > $out";
      };
      pkg-config = testers.hasPkgConfigModules {
        package = finalAttrs.finalPackage.dev;
        versionCheck = true;
      };
      cmake-config = testers.hasCmakeConfigModules {
        package = finalAttrs.finalPackage.dev;
        moduleNames = [ "ghostty-vt" ];
        versionCheck = true;
      };
    };
  };

  meta = {
    description = "Ghostty's VT (terminal sequence) parsing library";
    homepage = "https://ghostty.org/";
    license = lib.licenses.mit;
    pkgConfigModules = [
      "libghostty-vt"
      "libghostty-vt-static"
    ];
    maintainers = with lib.maintainers; [ domenkozar ];
    platforms = zig_0_17.meta.platforms;
  };
})
