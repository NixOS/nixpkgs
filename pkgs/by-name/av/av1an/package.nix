{
  lib,
  symlinkJoin,
  makeBinaryWrapper,
  testers,
  av1an-unwrapped,
  ffmpeg,
  python3Packages,
  libaom,
  svt-av1,
  rav1e,
  libvpx,
  x264,
  x265,
  libvmaf,
  withAom ? true, # AV1 reference encoder
  withSvtav1 ? false, # AV1 encoder/decoder (focused on speed and correctness)
  withRav1e ? false, # AV1 encoder (focused on speed and safety)
  withVpx ? true, # VP8 & VP9 de/encoding
  withX264 ? true, # H.264/AVC encoder
  withX265 ? true, # H.265/HEVC encoder
  withVmaf ? false, # Perceptual video quality assessment algorithm
}:
# av1an requires at least one encoder
assert lib.assertMsg (lib.elem true [
  withAom
  withSvtav1
  withRav1e
  withVpx
  withX264
  withX265
]) "At least one encoder is required!";
symlinkJoin {
  name = "av1an-${av1an-unwrapped.version}";

  paths = [ av1an-unwrapped ];

  nativeBuildInputs = [ makeBinaryWrapper ];

  postBuild =
    let
      runtimePrograms =
        [ (ffmpeg.override { inherit withVmaf; }) ]
        ++ lib.optional withAom libaom
        ++ lib.optional withSvtav1 svt-av1
        ++ lib.optional withRav1e rav1e
        ++ lib.optional withVpx libvpx
        ++ lib.optional withX264 x264
        ++ lib.optional withX265 x265
        ++ lib.optional withVmaf libvmaf;
    in
    ''
      wrapProgram $out/bin/av1an \
        --prefix PATH : ${lib.makeBinPath runtimePrograms} \
        --prefix PYTHONPATH : ${python3Packages.makePythonPath [ python3Packages.vapoursynth ]}
    '';

  passthru = {
    # TODO: uncomment when upstream actually bumps CARGO_PKG_VERSION
    #tests.version = testers.testVersion {
    #  package = av1an;
    #  inherit (av1an-unwrapped) version;
    #};
  };

  meta = {
    inherit (av1an-unwrapped.meta)
      description
      longDescription
      homepage
      changelog
      license
      maintainers
      mainProgram
      ;
  };
}
