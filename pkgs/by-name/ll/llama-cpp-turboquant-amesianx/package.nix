{
  lib,
  fetchFromGitHub,
  llama-cpp,
  nix-update-script,
}:

llama-cpp.overrideAttrs (oa: {
  pname = "llama-cpp-turboquant";

  src = fetchFromGitHub {
    owner = "AmesianX";
    repo = "TurboQuant";
    rev = "v1.6.0";
    hash = "sha256-K/07z6xePGV2AJD38AHy2XDIeS1hEeng4hrR/nP5UQQ=";
    leaveDotGit = true;
    postFetch = ''
      git -C "$out" rev-parse --short HEAD > $out/COMMIT
      find "$out" -name .git -print0 | xargs -0 rm -rf
    '';
  };

  npmDepsHash = "sha256-RAFtsbBGBjteCt5yXhrmHL39rIDJMCFBETgzId2eRRk=";

  strictDeps = true;

  __structuredAttrs = false;

  cmakeFlags = oa.cmakeFlags ++ [
    # Disables automatic use of ccache or sccache — compiler caching tools that speed up rebuilds by caching compilation results
    (lib.cmakeBool "GGML_CCACHE" false)

    # Disables Microsoft's DirectML backend for GGML — a hardware-accelerated compute API on Windows
    (lib.cmakeBool "GGML_DML" false)

    # F16C provides a fast hardware instruction for converting between: float (32b) ↔ half (16b) FP
    (lib.cmakeBool "GGML_F16C" true)

    # FMA (Fused Multiply-Add) CPU instruction set combines a multiplication and addition into a single CPU instruction: a = a*b + c
    (lib.cmakeBool "GGML_FMA" true)
  ];

  passthru.updateScript = nix-update-script {
    attrPath = "llama-cpp-turboquant-amesianx";
    extraArgs = [
      "--version-regex"
      "v(.*)"
    ];
  };

  meta = {
    description = "LLaMA-CPP with TurboQuant KV cache compression";
    homepage = "https://github.com/AmesianX/TurboQuant";
    license = lib.licenses.mit;
    mainProgram = "llama";
    maintainers = [ ];
    platforms = lib.platforms.unix;
  };
})
