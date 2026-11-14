{ lib
, stdenv
, fetchFromGitHub
, fetchpatch
, cmake
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "obj2voxel";
  version = "1.3.4";

  src = (
    fetchFromGitHub {
      owner = "Eisenwave";
      repo = "obj2voxel";
      rev = "v${finalAttrs.version}";
      fetchSubmodules = true;
      hash = "sha256-FkGQjYm15le1Na+2U1TgK4nNOZNs5bME5J87pjVFpDs=";
    }
  ).overrideAttrs (
    # prompted by https://github.com/Eisenwave/obj2voxel/pull/9
    _: {
      GIT_CONFIG_KEY_0 = "url.https://github.com/.insteadOf";
      GIT_CONFIG_VALUE_0 = "git@github.com:";
      GIT_CONFIG_COUNT = 1;
    }
  );

  patches = [
    # pull missing definitions (https://github.com/Eisenwave/voxel-io/pull/3)
    (
      fetchpatch {
        name = "add-std-includes.patch";
        url = "https://github.com/Eisenwave/voxel-io/compare/d902568de2d4afda254e533a5ee9e4ad5fe7d2be...2f800f6aca8acd0cc18f9625b411c6dc2956f2ea.patch";
        hash = "sha256-2JeFBx0Ds++BplWXuxOo4KOAW6gXCT/kFI74i0M0ROM=";
        stripLen = 1;
        extraPrefix = "voxelio/";
      }
    )
    # fix build on aarch64-darwin (https://github.com/Eisenwave/voxel-io/pull/4)
    (
      fetchpatch {
        name = "fix-aarch64-darwin-type-mismatch.patch";
        url = "https://github.com/Eisenwave/voxel-io/compare/d902568de2d4afda254e533a5ee9e4ad5fe7d2be...669ac7e9c640fa92bc1989cc7811afbed9bbd8b8.patch";
        hash = "sha256-AuvjpTGBLKN0f47IoxIDkV32g9A/4RbvGBo3ToGiH/w=";
        stripLen = 1;
        extraPrefix = "voxelio/";
      }
    )
    # already fixed in upstream git head
    ./1.3.4-fix-type-mismatch.patch
  ];

  postPatch = ''
    echo 'install(TARGETS obj2voxel-cli DESTINATION ''${CMAKE_INSTALL_PREFIX}/bin)' >> CMakeLists.txt
  '';

  cmakeFlags = [
    "-DBUILD_SHARED_LIBS=${if stdenv.targetPlatform.isStatic then "OFF" else "ON"}"
  ];

  strictDeps = true;

  nativeBuildInputs = [ cmake ];

  meta = with lib; {
    description = "Convert OBJ and STL files to voxels, with support for textures";
    mainProgram = "obj2voxel";
    homepage = "https://github.com/Eisenwave/obj2voxel";
    license = licenses.mit;
    platforms = platforms.unix;
    maintainers = [ maintainers.gm6k ];
  };
})
