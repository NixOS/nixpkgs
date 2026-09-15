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
  runCommand,
  xcbuild,
  zig_0_16,

  optimize ? "ReleaseFast",
  simd ? true,
}:
stdenv.mkDerivation (finalAttrs: {
  pname = "libghostty-vt";
  version = "0.1.0-unstable-2026-08-06";

  src = fetchFromGitHub {
    owner = "ghostty-org";
    repo = "ghostty";
    rev = "22d13172cde98a0a4dda05d3d6a3fcb0dd8ed018";
    hash = "sha256-tRtgTg/i3w1nFdRHU2IGekfJN8EyP+HARW4MtoUZyqk=";
  };

  # Zig's build runner computes relative paths from `cwd` to the build directory.
  # The logic is purely lexical, so if the `cwd` is a symlink that resolves to a
  # different depth during `chdir`, the computed path becomes incorrect.
  # See: https://codeberg.org/ziglang/zig/issues/32121
  # Workaround: override `linkFarm` with a copy-farm so deps are real directories.
  deps = callPackage ./deps.nix {
    name = "${finalAttrs.pname}-cache-${finalAttrs.version}";
    linkFarm =
      name: entries:
      runCommand name { } ''
        mkdir -p $out
        ${lib.concatMapStringsSep "\n" (e: ''
          cp -rL ${e.path} $out/${e.name}
        '') entries}
      '';
  };

  __structuredAttrs = true;
  strictDeps = true;

  nativeBuildInputs = [
    gitMinimal
    ncurses
    pkg-config
    zig_0_16
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

  meta = {
    description = "Ghostty's VT (terminal sequence) parsing library";
    homepage = "https://ghostty.org/";
    license = lib.licenses.mit;
    pkgConfigModules = [
      "libghostty-vt"
      "libghostty-vt-static"
    ];
    maintainers = with lib.maintainers; [ domenkozar ];
    platforms = zig_0_16.meta.platforms;
  };
})
