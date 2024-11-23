{
  lib,
  stdenv,
  fetchgit,
  python3,
  cmake,
  jq,
}:

stdenv.mkDerivation rec {
  pname = "swiftshader";
  version = "2023-09-11";

  src = fetchgit {
    url = "https://swiftshader.googlesource.com/SwiftShader";
    rev = "4e40d502c440cc59b25fa3a5fee0eadbab7442aa";
    hash = "sha256-YtbTaOkFhVMKdu3jiRHQsPmoEu3KDzIQXLZ5HFBSmWI=";
    # Remove 1GB of test files to get under Hydra output limit
    postFetch = ''
      rm -r $out/third_party/llvm-project/llvm/test
      rm -r $out/third_party/json/test
      rm -r $out/third_party/cppdap/third_party/json/test
      rm -r $out/third_party/llvm-project/clang/test
    '';
  };

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

  meta = with lib; {
    description = "A high-performance CPU-based implementation of the Vulkan 1.3 graphics API";
    homepage = "https://opensource.google/projects/swiftshader";
    license = licenses.asl20;
    # Should be possible to support Darwin by changing the install phase with
    # 's/Linux/Darwin/' and 's/so/dylib/' or something similar.
    platforms = with platforms; linux;
    maintainers = [ ];
  };
}
