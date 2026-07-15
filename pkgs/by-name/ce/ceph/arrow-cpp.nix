{
  arrow-cpp,
  fetchFromGitHub,
}:

# Ceph's `s3select` code (`src/s3select`) includes `arrow/util/span.h`, which
# `arrow-cpp` removed in version 24.0.0 in favour of `std::span`:
#     https://github.com/apache/arrow/pull/49492
# This broke the Ceph build once nixpkgs' `arrow-cpp` was bumped to 24.0.0:
#     https://github.com/NixOS/nixpkgs/issues/542206
# There is no upstream Ceph fix available yet, so we vendor the last `arrow-cpp`
# version that still ships `arrow/util/span.h` (23.0.0) for use by Ceph only.
arrow-cpp.overrideAttrs (finalAttrs: {
  version = "23.0.0";
  src = fetchFromGitHub {
    owner = "apache";
    repo = "arrow";
    rev = "apache-arrow-${finalAttrs.version}";
    hash = "sha256-BluUlbtGJwvlrpN/c/KziOfFh5dvzZyuCy4JZkkFea4=";
  };
})
