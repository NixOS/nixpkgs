{
  lib,
  av1an,
  av1an-unwrapped,
  ffmpeg,
  libaom,
  libvmaf,
  libvpx,
  makeBinaryWrapper,
  mkvtoolnix-cli,
  python3,
  rav1e,
  svt-av1,
  symlinkJoin,
  testers,
  vapoursynth,
  x264,
  x265,
  withAom ? true, # AV1 reference encoder
  withSvtav1 ? false, # AV1 encoder/decoder (focused on speed and correctness)
  withRav1e ? false, # AV1 encoder (focused on speed and safety)
  withVpx ? true, # VP8 & VP9 de/encoding
  withX264 ? true, # H.264/AVC encoder
  withX265 ? true, # H.265/HEVC encoder
  withVmaf ? false, # Perceptual video quality assessment algorithm
  withMkvtoolnix ? true, # mkv editor, recommended concatenation method
}:

# av1an requires at least one encoder
assert lib.assertMsg (lib.elem true [
  withAom
  withRav1e
  withSvtav1
  withVpx
  withX264
  withX265
]) "At least one encoder is required!";

symlinkJoin {
  pname = "av1an";
  inherit (av1an-unwrapped) version;

  paths = [ av1an-unwrapped ];

  nativeBuildInputs = [ makeBinaryWrapper ];

  postBuild =
    let
      runtimePrograms = [
        vapoursynth
        (ffmpeg.override { inherit withVmaf; })
      ]
      ++ lib.optional withAom libaom
      ++ lib.optional withMkvtoolnix mkvtoolnix-cli
      ++ lib.optional withRav1e rav1e
      ++ lib.optional withSvtav1 svt-av1
      ++ lib.optional withVmaf libvmaf
      ++ lib.optional withVpx libvpx
      ++ lib.optional withX264 x264
      ++ lib.optional withX265 x265;
    in
    ''
      wrapProgram $out/bin/av1an \
        --prefix LD_LIBRARY_PATH : ${vapoursynth}/lib \
        --prefix PATH : ${lib.makeBinPath runtimePrograms} \
        --prefix PYTHONPATH : ${vapoursynth}/${python3.sitePackages}
    '';

  passthru = {
    tests.version = testers.testVersion {
      package = av1an;
      inherit (av1an-unwrapped) version;
    };
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
      broken
      ;
  };
}
