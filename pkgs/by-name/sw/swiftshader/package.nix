{
  lib,
  stdenv,
  fetchgit,
  python3,
  cmake,
  jq,
}:

stdenv.mkDerivation {
  pname = "swiftshader";
  version = "2025-10-15";

  src = fetchgit {
    url = "https://swiftshader.googlesource.com/SwiftShader";
    rev = "3d536c0fc62b1cdea0f78c3c38d79be559855b88";
    hash = "sha256-RLc9ZJeq/97mi4/5vRnPPOPBHK2lc9/6Y7p1YVwxWkc=";
    # Remove 1GB of test files to get under Hydra output limit
    postFetch = ''
      rm -r $out/third_party/llvm-project/llvm/test
      rm -r $out/third_party/json/test
      rm -r $out/third_party/cppdap/third_party/json/test
      rm -r $out/third_party/llvm-project/clang/test
    '';
  };

  postPatch = ''
    substituteInPlace third_party/googletest/CMakeLists.txt \
      --replace-fail "cmake_minimum_required(VERSION 2.8.12)" "cmake_minimum_required(VERSION 3.5)"
    substituteInPlace third_party/googletest/googlemock/CMakeLists.txt \
      --replace-fail "cmake_minimum_required(VERSION 2.8.12)" "cmake_minimum_required(VERSION 3.5)"
    substituteInPlace third_party/googletest/googletest/CMakeLists.txt \
      --replace-fail "cmake_minimum_required(VERSION 2.8.12)" "cmake_minimum_required(VERSION 3.5)"
    substituteInPlace third_party/marl/CMakeLists.txt \
      --replace-fail  "cmake_minimum_required(VERSION 3.0)" "cmake_minimum_required(VERSION 3.5)"
  '';

  nativeBuildInputs = [
    cmake
    python3
    jq
  ];

  # Make sure we include the drivers and icd files in the output as the cmake
  # generated install command only puts in the spirv-tools stuff.
  installPhase = ''
    runHook preInstall

    #
    # Vulkan driver
    #
    vk_so_path="$out/lib/libvk_swiftshader.so"
    mkdir -p "$(dirname "$vk_so_path")"
    mv Linux/libvk_swiftshader.so "$vk_so_path"

    vk_icd_json="$out/share/vulkan/icd.d/vk_swiftshader_icd.json"
    mkdir -p "$(dirname "$vk_icd_json")"
    jq ".ICD.library_path = \"$vk_so_path\"" <Linux/vk_swiftshader_icd.json >"$vk_icd_json"

    runHook postInstall
  '';

  meta = {
    description = "High-performance CPU-based implementation of the Vulkan 1.3 graphics API";
    homepage = "https://opensource.google/projects/swiftshader";
    license = lib.licenses.asl20;
    # Should be possible to support Darwin by changing the install phase with
    # 's/Linux/Darwin/' and 's/so/dylib/' or something similar.
    platforms = lib.platforms.linux;
    maintainers = [ ];
  };
}
