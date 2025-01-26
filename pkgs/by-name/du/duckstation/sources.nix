{
  lib,
  duckstation,
  fetchFromGitHub,
  fetchpatch,
  shaderc,
  spirv-cross,
  discord-rpc,
  stdenv,
  cmake,
  ninja,
}:

{
  duckstation =
    let
      self = {
        pname = "duckstation";
        version = "0.1-7465";
        src = fetchFromGitHub {
          owner = "stenzek";
          repo = "duckstation";
          rev = "aa955b8ae28314ae061613f0ddf13183a98aca03";
          #
          # Some files are filled by using Git commands; it requires deepClone.
          # More info at `checkout_ref` function in nix-prefetch-git.
          # However, `.git` is a bit nondeterministic (and Git itself makes no
          # guarrantees whatsoever).
          # Then, in order to enhance reproducibility, what we will do here is:
          #
          # - Execute the desired Git commands;
          # - Save the obtained info into files;
          # - Remove `.git` afterwards.
          #
          deepClone = true;
          postFetch = ''
            cd $out
            mkdir -p .nixpkgs-auxfiles/
            git rev-parse HEAD > .nixpkgs-auxfiles/git_hash
            git rev-parse --abbrev-ref HEAD | tr -d '\r\n' > .nixpkgs-auxfiles/git_branch
            git describe --dirty | tr -d '\r\n' > .nixpkgs-auxfiles/git_tag
            git log -1 --date=iso8601-strict --format=%cd > .nixpkgs-auxfiles/git_date
            find $out -name .git -print0 | xargs -0 rm -fr
          '';
          hash = "sha256-ixrlr7Rm6GZAn/kh2sSeCCiK/qdmQ5+5jbbhAKjTx/E=";
        };
      };
    in
    self;

  shaderc-patched = shaderc.overrideAttrs (
    old:
    let
      version = "2024.3-unstable-2024-08-24";
      src = fetchFromGitHub {
        owner = "stenzek";
        repo = "shaderc";
        rev = "f60bb80e255144e71776e2ad570d89b78ea2ab4f";
        hash = "sha256-puZxkrEVhhUT4UcCtEDmtOMX4ugkB6ooMhKRBlb++lE=";
      };
    in
    {
      pname = "shaderc-patched-for-duckstation";
      inherit version src;
      patches = (old.patches or [ ]);
      cmakeFlags = (old.cmakeFlags or [ ]) ++ [
        (lib.cmakeBool "SHADERC_SKIP_EXAMPLES" true)
        (lib.cmakeBool "SHADERC_SKIP_TESTS" true)
      ];
      outputs = [
        "out"
        "lib"
        "dev"
      ];
      postFixup = '''';
    }
  );
  spirv-cross-patched = spirv-cross.overrideAttrs (
    old:
    let
      version = "1.3.290.0";
      src = fetchFromGitHub {
        owner = "KhronosGroup";
        repo = "SPIRV-Cross";
        rev = "vulkan-sdk-${version}";
        hash = "sha256-h5My9PbPq1l03xpXQQFolNy7G1RhExtTH6qPg7vVF/8=";
      };
    in
    {
      pname = "spirv-cross-patched-for-duckstation";
      inherit version src;
      patches = (old.patches or [ ]);
      cmakeFlags = (old.cmakeFlags or [ ]) ++ [
        (lib.cmakeBool "SPIRV_CROSS_CLI" false)
        (lib.cmakeBool "SPIRV_CROSS_ENABLE_CPP" false)
        (lib.cmakeBool "SPIRV_CROSS_ENABLE_C_API" true)
        (lib.cmakeBool "SPIRV_CROSS_ENABLE_GLSL" true)
        (lib.cmakeBool "SPIRV_CROSS_ENABLE_HLSL" false)
        (lib.cmakeBool "SPIRV_CROSS_ENABLE_MSL" false)
        (lib.cmakeBool "SPIRV_CROSS_ENABLE_REFLECT" false)
        (lib.cmakeBool "SPIRV_CROSS_ENABLE_TESTS" false)
        (lib.cmakeBool "SPIRV_CROSS_ENABLE_UTIL" true)
        (lib.cmakeBool "SPIRV_CROSS_SHARED" true)
        (lib.cmakeBool "SPIRV_CROSS_STATIC" false)
      ];
    }
  );
  discord-rpc-patched = discord-rpc.overrideAttrs (old: {
    pname = "discord-rpc-patched-for-duckstation";
    version = "3.4.0-unstable-2024-08-02";
    src = fetchFromGitHub {
      owner = "stenzek";
      repo = "discord-rpc";
      rev = "144f3a3f1209994d8d9e8a87964a989cb9911c1e";
      hash = "sha256-VyL8bEjY001eHWcEoUPIAFDAmaAbwcNb1hqlV2a3cWs=";
    };
    patches = (old.patches or [ ]);
  });

  soundtouch-patched = stdenv.mkDerivation (finalAttrs: {
    pname = "soundtouch-patched-for-duckstation";
    version = "2.2.3-unstable-2024-08-02";
    src = fetchFromGitHub {
      owner = "stenzek";
      repo = "soundtouch";
      rev = "463ade388f3a51da078dc9ed062bf28e4ba29da7";
      hash = "sha256-hvBW/z+fmh/itNsJnlDBtiI1DZmUMO9TpHEztjo2pA0=";
    };

    nativeBuildInputs = [
      cmake
      ninja
    ];

    meta = {
      homepage = "https://github.com/stenzek/soundtouch";
      description = "SoundTouch Audio Processing Library (forked from https://codeberg.org/soundtouch/soundtouch)";
      license = lib.licenses.lgpl21;
      platforms = lib.platforms.linux;
    };

  });

  lunasvg = stdenv.mkDerivation (finalAttrs: {
    pname = "lunasvg-patched-for-duckstation";
    version = "2.4.1-unstable-2024-08-24";
    src = fetchFromGitHub {
      owner = "stenzek";
      repo = "lunasvg";
      rev = "9af1ac7b90658a279b372add52d6f77a4ebb482c";
      hash = "sha256-ZzOe84ZF5JRrJ9Lev2lwYOccqtEGcf76dyCDBDTvI2o=";
    };

    nativeBuildInputs = [
      cmake
      ninja
    ];

    meta = {
      homepage = "https://github.com/stenzek/lunasvg";
      description = "lunasvg is a standalone SVG rendering library in C++";
      license = lib.licenses.mit;
      platforms = lib.platforms.linux;
    };
  });
}
