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
  # against (its build.rs's MLN_COMMIT). It is unfortunate that this is not
  # one of upstream's `core-*` tags, but since this is being added for the
  # sake of Martin (which we already have in Nixpkgs), I think we should just
  # live with this semi-arbitrary choice of commit for now.
  #
  # When Martin 2 is released, we will be able to swap out this commit for
  # one of the `core-*` tags after all.
  #
  # The `core-*` tags are the closest thing to a `maplibre-native` release (for
  # non-mobile), so that is indeed what we should end up using.
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
  # newer maplibre-native. Some of the PRs are in fact already merged:
  #
  # - https://github.com/maplibre/maplibre-native/pull/5073
  # - https://github.com/maplibre/maplibre-native/pull/5076
  # - https://github.com/maplibre/maplibre-native/pull/5077
  # - https://github.com/maplibre/maplibre-native/pull/5079
  #
  # These are still open:
  #
  # - https://github.com/maplibre/maplibre-native/pull/5078
  # - https://github.com/maplibre/maplibre-native/pull/5071
  #
  # We are on track to have all PRs merged soon, so that when we update
  # this package, all this will go away.
  patches = [
    (fetchpatch2 {
      name = "define-vendored-glslang-in-own-file.patch";
      url = "https://github.com/maplibre/maplibre-native/commit/7825af56fa3106632debf5f799f62ee50d68de9b.patch?full_index=1";
      hash = "sha256-JCA6Kcvh+55JbFhthHDcq32y1lke96eW4piXB9ut1HE=";
    })
    # Upstream preferred a mix of improvements and cleanups, touching more lines
    # of code, which means, except for the above, nothing actually applies
    # cleanly to this version.
    #
    # As such we have instead condensed what we need into this patch. See its
    # commit message for further details.
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

  # Header-only, and only included by the core's own sources, not its installed
  # headers, so whatever links the core does not need it.
  buildInputs = [ protozero ];

  # `mbgl-core` is a static library, so whatever links it also needs to
  # link these. Cf. `pkgsStatic` making all build inputs propagated.
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
  # version with `MLN_WITH_TOOLS`
  # (https://github.com/maplibre/maplibre-native/pull/5073) and
  # `MLN_WITH_TESTS` (https://github.com/maplibre/maplibre-native/pull/5078)
  # can be used, by switching those off instead.
  #
  # Those PRs do not apply to this earlier version, and this work-around is
  # less code to include than vendored backports of those PRs would be.
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
    maintainers = with lib.maintainers; [ ericson2314 ];
    teams = [ lib.teams.geospatial ];
    platforms = lib.platforms.linux;
  };
}
