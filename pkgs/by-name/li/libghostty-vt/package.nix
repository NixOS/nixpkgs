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
  testers,
  xcbuild,
  zig_0_17,

  optimize ? "ReleaseFast",
  simd ? true,
}:
stdenv.mkDerivation (finalAttrs: {
  pname = "libghostty-vt";
  version = "1.4.0";

  src = fetchFromGitHub {
    owner = "ghostty-org";
    repo = "ghostty";
    tag = "v${finalAttrs.version}";
    hash = "sha256-ywmIjwix0P5TC8kD/zTmt82CNrLXMFETaWZj0NirpoM=";
  };

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
    substituteInPlace "$dev/share/pkgconfig/libghostty-vt-static.pc" \
      --replace-fail "$out" "$dev"
  '';

  passthru.tests = {
    pkg-config = testers.hasPkgConfigModules {
      package = finalAttrs.finalPackage.dev;
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
