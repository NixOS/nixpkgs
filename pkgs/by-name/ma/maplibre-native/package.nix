{
  lib,
  stdenv,
  fetchFromGitHub,
  fetchpatch2,
  cmake,
  ninja,
  pkg-config,
  boost,
  curl,
  expected-lite,
  freetype,
  glslang,
  harfbuzz,
  icu,
  libjpeg,
  libpng,
  libuv,
  libwebp,
  nunicode,
  protozero,
  rapidjson,
  spirv-tools,
  sqlite,
  unordered_dense,
  vulkan-headers,
  vulkan-memory-allocator,
  zlib,
}:

stdenv.mkDerivation {
  pname = "maplibre-native";
  version = "0-unstable-2026-07-13";

  # This commit is the one that the maplibre_native Rust crate is written
  # against (its build.rs's MLN_COMMIT). It is unfortunately to not pin a
  # release, but since this is being adding for sake of martin (which we
  # already have in Nixpkgs), I think we should just live with this for now.
  #
  # When Martin 2 is released, we will able to swap out this semi-arbitrary
  # commit hash for one of the `core-*` tags that are the closest thing to a
  # `maplibre-native` release (for non-mobile).
  src = fetchFromGitHub {
    owner = "maplibre";
    repo = "maplibre-native";
    rev = "f442c704b806d6f1e64242aa462a31c6f128cf47";
    fetchSubmodules = true;
    hash = "sha256-zhPfuH7zsem2XQ0ZQjUEu5vxmCvTnGUR9x5Uxhd6zao=";
  };

  outputs = [
    "out"
    "dev"
  ];

  # Making maplibre-native easier to package is being upstreamed, against a
  # newer maplibre-native, in these PRs:
  #
  # - https://github.com/maplibre/maplibre-native/pull/5073 (`MLN_WITH_TOOLS`)
  # - https://github.com/maplibre/maplibre-native/pull/5076 (grouping the
  #   default platform's sources)
  # - https://github.com/maplibre/maplibre-native/pull/5077 (the test runners
  #   next to their sources)
  # - https://github.com/maplibre/maplibre-native/pull/5078 (`BUILD_TESTING`)
  # - https://github.com/maplibre/maplibre-native/pull/5079 (glslang's own
  #   vendor file)
  # - https://github.com/maplibre/maplibre-native/pull/5071 (install rules,
  #   installed dependencies and the pkg-config file)
  #
  # Of them, these patches build against installed libraries rather than the
  # vendored copies, and install the core, with a pkg-config file. Delete them
  # once a commit with those PRs can be used.
  patches = [
    (fetchpatch2 {
      name = "define-vendored-glslang-in-own-file.patch";
      url = "https://github.com/maplibre/maplibre-native/commit/7825af56fa3106632debf5f799f62ee50d68de9b.patch?full_index=1";
      hash = "sha256-JCA6Kcvh+55JbFhthHDcq32y1lke96eW4piXB9ut1HE=";
    })
    # A short backport of the rest to this version.
    ./use-installed-dependencies-and-install.patch
  ];

  # The installed libraries are used instead, so make sure nothing still uses
  # these.
  postPatch = ''
    rm -r vendor/{boost,expected-lite,freetype,glslang,harfbuzz,nunicode,protozero,rapidjson,sqlite,unordered_dense,Vulkan-Headers,VulkanMemoryAllocator}
    rm vendor/{glslang,unordered_dense,vulkan}.cmake
  '';

  strictDeps = true;
  __structuredAttrs = true;

  nativeBuildInputs = [
    cmake
    ninja
    pkg-config
  ];

  # `mbgl-core` is a static library, so whatever links it also needs to
  # link these. Cf. `pkgsStatic` making all build inputs propagated.
  buildInputs = [ protozero ];

  propagatedBuildInputs = [
    boost
    curl
    expected-lite
    freetype
    glslang
    harfbuzz
    icu
    libjpeg
    libpng
    libuv
    libwebp
    nunicode
    rapidjson
    spirv-tools
    sqlite
    unordered_dense
    vulkan-headers
    vulkan-memory-allocator
    zlib
  ];

  # The core library only, rendering with Vulkan, without any windowing. This
  # is like upstream's `linux-vulkan` preset that it builds for its releases,
  # except that the preset enables X11.
  cmakeFlags = [
    (lib.cmakeBool "MLN_WITH_VULKAN" true)
    (lib.cmakeBool "MLN_WITH_X11" false)
    (lib.cmakeBool "MLN_WITH_WAYLAND" false)
    (lib.cmakeBool "MLN_WITH_GLFW" false)
    (lib.cmakeBool "MLN_WITH_CLANG_TIDY" false)
    (lib.cmakeBool "MLN_WITH_WERROR" false)
  ];

  # Build just the core, without the tools and tests. TODO delete once a
  # version with `MLN_WITH_TOOLS` and `BUILD_TESTING` (see above) can be used,
  # where they are switched off instead. Those PRs do not apply to this earlier
  # version, and this work-around is much less to include than backports of
  # them would be.
  ninjaFlags = [ "mbgl-core" ];

  # TODO delete too, as described above.
  installPhase = ''
    runHook preInstall
    cmake --install . --component core
    runHook postInstall
  '';

  meta = {
    description = "Core library for rendering maps from MapLibre styles";
    homepage = "https://maplibre.org/projects/native/";
    license = lib.licenses.bsd2;
    teams = [ lib.teams.geospatial ];
    platforms = lib.platforms.linux;
  };
}
