{
  lib,
  stdenv,
  fetchFromGitHub,
  fetchzip,

  # nativeBuildInputs
  meson,
  ninja,
  pkg-config,

  # buildInputs
  arrow-cpp,
  gbenchmark,
  gtest,
  nlohmann_json,
  zlib,
  zstd,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "nanoarrow";
  version = "0.8.0";
  __structuredAttrs = true;
  strictDeps = true;

  src = fetchFromGitHub {
    owner = "apache";
    repo = "arrow-nanoarrow";
    tag = "apache-arrow-nanoarrow-${finalAttrs.version}";
    hash = "sha256-1iLbT1eeyZaoB75uYTgg4qns+C7b4DErqMwJ9nQPRls=";
  };

  nativeBuildInputs = [
    meson
    ninja
    pkg-config
  ];

  buildInputs = [
    arrow-cpp
    gbenchmark
    gtest
    nlohmann_json
    zlib
    zstd
  ];

  doCheck = true;

  # Pre-populate the meson subproject with the flatcc source so meson doesn't try to download it.
  # The wrap's patch_directory overlay (meson.build) must also be applied.
  postPatch = ''
    cp -r --no-preserve=mode ${finalAttrs.finalPackage.passthru.flatcc-src} ${finalAttrs.finalPackage.passthru.flatcc-src-dest}
    cp subprojects/packagefiles/flatcc/meson.build ${finalAttrs.finalPackage.passthru.flatcc-src-dest}/
  '';
  mesonFlags = [
    # Needed only on Darwin, because otherwise a metal-cpp dependency is
    # required. It doesn't hurt to enable it for all platforms, so it'd be
    # easier to spot if the option will disappear in the future for instance..
    (lib.mesonOption "metal" "disabled")
  ];

  passthru = {
    # Nanoarrow requires a specific post-0.6.1 flatcc commit that adds `_with_size` API variants not
    # present in the upstream 0.6.1 release.
    flatcc-src = fetchFromGitHub {
      owner = "dvidelabs";
      repo = "flatcc";
      rev = "fd3c4ae5cd39f0651eda6a3a1a374278070135d6";
      hash = "sha256-8MqazKuwfFWVJ/yjT5fNrRzexFQ2ky4YTcZqOYjk9Qc=";
    };
    flatcc-src-dest = "subprojects/flatcc-${finalAttrs.finalPackage.passthru.flatcc-src.rev}";
  };

  outputs = [
    "out"
    "dev"
  ];

  meta = {
    description = "Helpers for Arrow C Data & Arrow C Stream interfaces";
    homepage = "https://github.com/apache/arrow-nanoarrow";
    changelog = "https://github.com/apache/arrow-nanoarrow/blob/${finalAttrs.src.rev}/CHANGELOG.md";
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [ doronbehar ];
    platforms = lib.platforms.all;
  };
})
