{
  lib,
  stdenv,
  fetchFromGitHub,

  # nativeBuildInputs
  cmake,
  nasm,

  # buildInputs
  zlib,

  # nativeInstallCheckInputs
  versionCheckHook,

  # passthru
  runCommand,
  nix,
  pkgs,
  gitUpdater,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "isa-l";
  version = "2.32.1";

  __structuredAttrs = true;
  strictDeps = true;

  src = fetchFromGitHub {
    owner = "intel";
    repo = "isa-l";
    tag = "v${finalAttrs.version}";
    hash = "sha256-JizQXhfDCL8aWEv52TBuXw06HA/8t7Ram/q9vSp5/DI=";
  };

  nativeBuildInputs = [
    cmake
    nasm
  ];

  buildInputs = [
    zlib
  ];

  env = {
    NIX_CFLAGS_COMPILE = toString [
      "-DVERSION=\"${finalAttrs.version}\""
    ];
  };
  cmakeFlags = [
    (lib.cmakeBool "ISAL_BUILD_IGZIP_CLI" true)

    # https://github.com/NixOS/nixpkgs/issues/144170
    (lib.cmakeFeature "CMAKE_INSTALL_INCLUDEDIR" "include")
    (lib.cmakeFeature "CMAKE_INSTALL_LIBDIR" "lib")
  ];

  nativeInstallCheckInputs = [
    versionCheckHook
  ];
  doInstallCheck = true;

  passthru = {
    tests = {
      igzip =
        runCommand "test-isa-l-igzip"
          {
            nativeBuildInputs = [
              finalAttrs.finalPackage
            ];
            sample =
              runCommand "nixpkgs-lib.nar"
                {
                  nativeBuildInputs = [ nix ];
                }
                ''
                  nix nar --extra-experimental-features nix-command pack ${pkgs.path + "/lib"} > "$out"
                '';
            meta = {
              description = "Cross validation of igzip provided by isa-l with gzip";
            };
          }
          ''
            HASH_ORIGINAL="$(cat "$sample" | sha256sum | cut -d" " -f1)"
            HASH_COMPRESSION_TEST="$(igzip -c "$sample" | gzip -d -c | sha256sum | cut -d" " -f1)"
            HASH_DECOMPRESSION_TEST="$(gzip -c "$sample" | igzip -d -c | sha256sum | cut -d" " -f1)"
            if [[ "$HASH_COMPRESSION_TEST" != "$HASH_ORIGINAL" ]] || [[ "$HASH_DECOMPRESSION_TEST" != "$HASH_ORIGINAL" ]]; then
              if [[ "HASH_COMPRESSION_TEST" != "$HASH_ORIGINAL" ]]; then
                echo "The igzip-compressed file does not decompress to the original file." 1>&2
              fi
              if [[ "HASH_DECOMPRESSION_TEST" != "$HASH_ORIGINAL" ]]; then
                echo "igzip does not decompress the gzip-compressed archive to the original file." 1>&2
              fi
              echo "SHA256 checksums:" 1>&2
              printf '  original file:\t%s\n' "$HASH_ORIGINAL" 1>&2
              printf '  compression test:\t%s\n' "$HASH_COMPRESSION_TEST" 1>&2
              printf '  decompression test:\t%s\n' "$HASH_DECOMPRESSION_TEST" 1>&2
              exit 1
            fi
            touch "$out"
          '';
    };
    updateScript = gitUpdater { rev-prefix = "v"; };
  };

  meta = {
    description = "Collection of optimised low-level functions targeting storage applications";
    mainProgram = "igzip";
    license = lib.licenses.bsd3;
    homepage = "https://github.com/intel/isa-l";
    changelog = "https://github.com/intel/isa-l/releases/tag/v${finalAttrs.version}";
    maintainers = with lib.maintainers; [ jbedo ];
    platforms = lib.platforms.all;
    badPlatforms = [
      # <instantiation>:4:26: error: unexpected token in argument list
      #  movk x7, p4_low_b1, lsl 16
      "aarch64-darwin"
      # https://github.com/intel/isa-l/issues/188
      "i686-linux"
    ];
  };
})
