{
  lib,
  stdenv,
  callPackage,
  darwinMinVersionHook,
  fetchFromGitHub,
  rcodesign,
  zig_0_16,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "skhd-zig";
  version = "0.2.0";

  src = fetchFromGitHub {
    owner = "jackielii";
    repo = "skhd.zig";
    tag = "v${finalAttrs.version}";
    hash = "sha256-Qi5srrpdhf3VcXaqZbijJD23Um0G7WgRzK0hR+mb7nU=";
  };

  patches = [
    # Release archives have no Git metadata; use the upstream VERSION file.
    ./version.patch
  ];

  postPatch = ''
    # The allocation-tracing executable is only useful for upstream development.
    substituteInPlace build.zig \
      --replace-fail 'b.installArtifact(alloc_exe);' ""
  '';

  nativeBuildInputs = [
    rcodesign
    zig_0_16
  ];

  buildInputs = [ (darwinMinVersionHook "13.0") ];

  strictDeps = true;
  __structuredAttrs = true;

  # Generated with zig2nix's `zon2nix build.zig.zon`; regenerate on updates.
  deps = callPackage ./deps.nix {
    zig = zig_0_16;
  };

  postConfigure = ''
    ln -s ${finalAttrs.deps} "$ZIG_GLOBAL_CACHE_DIR/p"
  '';

  # The full suite queries the active macOS keyboard layout, which is not
  # available in a headless sandbox.
  doCheck = false;

  postInstall = ''
    # Recent macOS versions require an app bundle for Accessibility grants.
    # This only stages upstream's bundle; it does not register any services.
    bash scripts/make-app.sh "$out/bin/skhd" "$out/Applications/skhd.app"
    for program in skhd skhd-grabber; do
      rm "$out/bin/$program"
      ln -s "../Applications/skhd.app/Contents/MacOS/$program" "$out/bin/$program"
    done
  '';

  postFixup = ''
    rcodesign sign $out/Applications/skhd.app
  '';

  meta = {
    description = "Simple hotkey daemon for macOS, rewritten in Zig";
    homepage = "https://github.com/jackielii/skhd.zig";
    changelog = "https://github.com/jackielii/skhd.zig/blob/v${finalAttrs.version}/CHANGELOG.md";
    license = lib.licenses.mit;
    maintainers = [ lib.maintainers.vonfry ];
    mainProgram = "skhd";
    platforms = lib.platforms.darwin;
  };
})
