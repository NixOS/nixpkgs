{
  lib,
  symlinkJoin,
  makeBinaryWrapper,
  navidrome-unwrapped,
  ffmpeg-headless,
  ffmpegSupport ? true,
  plugins ? null,
  wasmPlugins ? [ ],
}:
assert lib.warnIf (plugins != null)
  "navidrome's 'plugins' input has been deprecated. Please use `navidrome.withPlugins (p: [ p.audiomuseai ])` to select plugins"
  true;
symlinkJoin (finalAttrs: {
  inherit (navidrome-unwrapped) version meta;
  pname = navidrome-unwrapped.pname + "-wrapped";

  __structuredAttrs = true;
  strictDeps = true;

  # Create a bash associated array between
  # the bundle names and the path to the derivation output.
  wasm_plugins = lib.listToAttrs (
    lib.map (p: {
      name = p.bundleName or p.pname;
      value = p.outPath;
    }) wasmPlugins
  );

  paths = [
    navidrome-unwrapped
  ];

  nativeBuildInputs = [
    makeBinaryWrapper
  ];

  postBuild = ''

    for name in "''${!wasm_plugins[@]}"; do
      # Only create the plugins dir if there is a plugin
      mkdir -p "$out/share/plugins"

      find "''${wasm_plugins["$name"]}" \
        -type f \
        -name "*.ndp" \
        -exec ln -s {} "$out/share/plugins/$name.ndp" \;
    done

    makeWrapper ${lib.getExe navidrome-unwrapped} "$out/bin/navidrome" \
      --prefix PATH : ${lib.makeBinPath [ ffmpeg-headless ]}
  '';

  passthru = {
    inherit (navidrome-unwrapped) withPlugins;
    tests = {
      unwrapped = navidrome-unwrapped.withPlugins (p: [ p.audiomuseai ]);
      wrapped = finalAttrs.finalPackage.withPlugins (p: [ p.audiomuseai ]);
    };
  };
})
