{ lib
, stdenv
, rustPlatform
, fetchFromGitHub
, vulkan-loader
}:

rustPlatform.buildRustPackage rec {
  pname = "memtest_vulkan";
  version = "0.5.0";

  src = fetchFromGitHub {
    owner = "GpuZelenograd";
    repo = "memtest_vulkan";
    rev = "v${version}";
    hash = "sha256-8tmQtycK7D5bol9v5VL8VkROZbSCndHo+uBvqqFTZjw=";
  };

  cargoHash = "sha256-8x8bS0LcvoxoSBWbGdkKzhxDi/9VNab26eidv8YK9dg=";

  # It doesn't discover this on its own :/
  # https://github.com/GpuZelenograd/memtest_vulkan/issues/36
  postFixup = lib.optionalString stdenv.targetPlatform.isElf ''
    patchelf $out/bin/memtest_vulkan --add-needed libvulkan.so --add-rpath ${lib.makeLibraryPath [ vulkan-loader ]}
  '';

  meta = with lib; {
    description = "Vulkan compute tool for testing video memory stability";
    homepage = "https://github.com/GpuZelenograd/memtest_vulkan";
    license = licenses.zlib;
    maintainers = with maintainers; [ atemu ];
    mainProgram = "memtest_vulkan";
    broken =
      stdenv.system == "aarch64-linux" # error: linker `aarch64-linux-gnu-gcc` not found
      || stdenv.isDarwin; # Can't find Vulkan; might work though?
  };
}
