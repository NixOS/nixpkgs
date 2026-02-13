{
  lib,
  stdenv,
  fetchFromGitHub,
  fetchpatch2,

  cmake,
  ninja,
  pkg-config,

  SDL2,
  libxt,
  libxrandr,
  libxaw,
  libx11,
  libxcb,
  libGL,
  zlib,
  freetype,
  tinyxml,
  openvr,
  rapidjson,
  zziplib,
}:
stdenv.mkDerivation (finalAttrs: {
  pname = "ogre-next";
  version = "3.0.0";

  src = fetchFromGitHub {
    owner = "OGRECave";
    repo = "ogre-next";
    tag = "v${finalAttrs.version}";
    hash = "sha256-nJkCGKl9+6gApVtqk5OZjTOJllAJIiBKuquTYvR4NPs=";
  };

  patches = [
    (fetchpatch2 {
      # https://github.com/OGRECave/ogre-next/pull/542
      url = "https://github.com/OGRECave/ogre-next/commit/c1dad50e8510dea9d75d97b0ace33a870993895c.patch?full_index=1";
      hash = "sha256-JYsksDxcLrkHqlgdP3KdHlFuvYxNazlchPGoTXE9LYQ=";
    })
  ];

  nativeBuildInputs = [
    cmake
    pkg-config
    ninja
  ];

  buildInputs = [
    SDL2
    freetype
    zziplib
    zlib
    tinyxml
    openvr
    rapidjson
  ]
  ++ lib.optionals stdenv.hostPlatform.isLinux [
    libGL
    libx11
    libxaw
    libxrandr
    libxt
    libxcb
  ];

  # TODO: Figure out Vulkan plugin deps

  cmakeFlags = [
    (lib.cmakeBool "OGRE_BUILD_COMPONENT_PLANAR_REFLECTIONS" true)

    # Use STB instead of freeimage since the latter is marked as insecure
    (lib.cmakeBool "OGRE_CONFIG_ENABLE_FREEIMAGE" false)
    (lib.cmakeBool "OGRE_CONFIG_ENABLE_STBI" true)
  ];

  meta = {
    description = "3D Object-Oriented Graphics Rendering Engine";
    homepage = "https://www.ogre3d.org/";
    maintainers = with lib.maintainers; [
      marcin-serwin
    ];
    platforms = lib.platforms.linux;
    license = lib.licenses.mit;

    # build problems around NEON intrinsics
    broken = stdenv.hostPlatform.isAarch64;
  };
})
