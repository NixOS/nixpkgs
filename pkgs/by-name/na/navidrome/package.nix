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

  paths = [
    navidrome-unwrapped
  ]
  ++ wasmPlugins;

  nativeBuildInputs = [
    makeBinaryWrapper
  ];

  postBuild = lib.optionalString ffmpegSupport ''
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
