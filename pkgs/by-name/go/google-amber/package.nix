{
  lib,
  stdenv,
  fetchFromGitHub,
  cmake,
  pkg-config,
  cctools,
  makeWrapper,
  mesa,
  python3,
  runCommand,
  vulkan-headers,
  vulkan-loader,
  vulkan-validation-layers,
}:
let
  # From https://github.com/google/amber/blob/main/DEPS
  glslang = fetchFromGitHub {
    owner = "KhronosGroup";
    repo = "glslang";
    rev = "340bf88f3fdb4f4a25b7071cd2c1205035fc6eaa";
    hash = "sha256-3h27yE6k4BgUAugQCkpUYO5aIHpK6Anyh90y3q+aYpM=";
  };

  lodepng = fetchFromGitHub {
    owner = "lvandeve";
    repo = "lodepng";
    rev = "5601b8272a6850b7c5d693dd0c0e16da50be8d8d";
    hash = "sha256-dD8QoyOoGov6VENFNTXWRmen4nYYleoZ8+4TpICNSpo=";
  };

  shaderc = fetchFromGitHub {
    owner = "google";
    repo = "shaderc";
    rev = "690d259384193c90c01b52288e280b05a8481121";
    hash = "sha256-p4tP/8lRy0tpdDHIuh2/tWPIBBr2ludFRSr+Q2TbUic=";
  };

  spirv-headers = fetchFromGitHub {
    owner = "KhronosGroup";
    repo = "SPIRV-Headers";
    rev = "3f17b2af6784bfa2c5aa5dbb8e0e74a607dd8b3b";
    hash = "sha256-MCQ+i9ymjnxRZP/Agk7rOGdHcB4p67jT4J4athWUlcI=";
  };

  spirv-tools = fetchFromGitHub {
    owner = "KhronosGroup";
    repo = "SPIRV-Tools";
    rev = "13b59bf1d84054b8ccd29cdc6b1303f69e8f9e77";
    hash = "sha256-k/mTHiLbZdnslC24fjcrzqsZYMyVaAADGEqngqJcC2c=";
  };

in
stdenv.mkDerivation (finalAttrs: {
  pname = "amber";
  version = "0-unstable-2025-02-03";

  src = fetchFromGitHub {
    owner = "google";
    repo = "amber";
    rev = "3f078e41d86ca1a5881560f00e26198f59bb8ac0";
    hash = "sha256-pAotVFmtEGp9GKmDD0vrbfbO+Xt2URmM8gYCjl0LEnk=";
  };

  buildInputs = [
    vulkan-headers
    vulkan-loader
  ];

  nativeBuildInputs = [
    cmake
    makeWrapper
    pkg-config
    python3
  ]
  ++ lib.optionals stdenv.hostPlatform.isDarwin [
    cctools
  ];

  # Tests are disabled so we do not have to pull in googletest and more dependencies
  cmakeFlags = [
    "-DAMBER_SKIP_TESTS=ON"
    "-DAMBER_DISABLE_WERROR=ON"
  ];

  prePatch = ''
    cp -r ${glslang}/ third_party/glslang
    cp -r ${lodepng}/ third_party/lodepng
    cp -r ${shaderc}/ third_party/shaderc
    cp -r ${spirv-tools}/ third_party/spirv-tools
    cp -r ${spirv-headers}/ third_party/spirv-headers
    chmod u+w -R third_party

    substituteInPlace tools/update_build_version.py \
      --replace "not os.path.exists(directory)" "True"
  '';

  installPhase = ''
    install -Dm755 -t $out/bin amber image_diff
    wrapProgram $out/bin/amber \
      --suffix VK_LAYER_PATH : ${vulkan-validation-layers}/share/vulkan/explicit_layer.d
  '';

  passthru.tests.lavapipe =
    runCommand "vulkan-cts-tests-lavapipe"
      {
        nativeBuildInputs = [
          finalAttrs.finalPackage
          mesa.llvmpipeHook
        ];
      }
      ''
        cat > test.amber <<EOF
        #!amber
        # Simple amber compute shader.

        SHADER compute kComputeShader GLSL
        #version 450

        layout(binding = 3) buffer block {
          uvec2 values[];
        };

        void main() {
          values[gl_WorkGroupID.x + gl_WorkGroupID.y * gl_NumWorkGroups.x] =
                        gl_WorkGroupID.xy;
        }
        END  # shader

        BUFFER kComputeBuffer DATA_TYPE vec2<int32> SIZE 524288 FILL 0

        PIPELINE compute kComputePipeline
          ATTACH kComputeShader
          BIND BUFFER kComputeBuffer AS storage DESCRIPTOR_SET 0 BINDING 3
        END  # pipeline

        RUN kComputePipeline 256 256 1

        # Four corners
        EXPECT kComputeBuffer IDX 0 EQ 0 0
        EXPECT kComputeBuffer IDX 2040 EQ 255 0
        EXPECT kComputeBuffer IDX 522240 EQ 0 255
        EXPECT kComputeBuffer IDX 524280 EQ 255 255

        # Center
        EXPECT kComputeBuffer IDX 263168 EQ 128 128
        EOF

        amber test.amber
        touch $out
      '';

  meta = with lib; {
    description = "Multi-API shader test framework";
    homepage = "https://github.com/google/amber";
    license = licenses.asl20;
    maintainers = with maintainers; [ Flakebi ];
  };
})
