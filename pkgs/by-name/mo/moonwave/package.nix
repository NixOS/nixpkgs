{
  lib,
  buildNpmPackage,
  rustPlatform,
  fetchFromGitHub,
  makeWrapper,
  nodejs,
  git,
}:

buildNpmPackage (finalAttrs: {
  pname = "moonwave";
  version = "1.4.2";
  __structuredAttrs = true;

  src = fetchFromGitHub {
    owner = "evaera";
    repo = "moonwave";
    tag = "v${finalAttrs.version}";
    hash = "sha256-aaNNHvvoJ3SKIiT48iJ7aNdBiNadpM/aOBjyiitjJzQ=";
  };

  sourceRoot = "${finalAttrs.src.name}/cli";

  npmDepsHash = "sha256-i8AWDjrSMIMaHRM7nDiQwf703M1i0BZepRE3Occ5i8g=";
  npmBuildScript = "tsc";

  nativeBuildInputs = [
    makeWrapper
  ];

  # Fix for moonwave copied templates from nix store being read-only due to nature of nix
  postPatch = ''
    substituteInPlace src/binary.ts \
      --replace-fail \
        'if (process.env.MOONWAVE_DEV) {' \
        'if (process.env.MOONWAVE_EXTRACTOR_PATH) {'

    substituteInPlace src/prepareProject.ts \
      --replace-fail \
        'const tempDir = path.join(cachedir("moonwave"), folderName)' \
        'const tempDir = path.join(cachedir("moonwave"), folderName)

    const MakeCacheWritable = (Target: string): void => {
      if (!fs.existsSync(Target)) return
      const Info = fs.lstatSync(Target)
      if (Info.isSymbolicLink()) return
      fs.chmodSync(Target, Info.mode | 0o200)
      if (Info.isDirectory()) {
        for (const Name of fs.readdirSync(Target)) {
          if (Name !== "node_modules") {
            MakeCacheWritable(path.join(Target, Name))
          }
        }
      }
    }

    MakeCacheWritable(tempDir)'
      substituteInPlace src/prepareProject.ts \
        --replace-fail \
          'fs.copySync(ROOT_PATH, tempDir)' \
          'fs.copySync(ROOT_PATH, tempDir)
      MakeCacheWritable(tempDir)'
  '';

  postFixup = ''
    wrapProgram "$out/bin/moonwave" \
      --set MOONWAVE_EXTRACTOR_PATH "${lib.getExe finalAttrs.passthru.extractor}" \
      --prefix PATH : ${
        lib.makeBinPath [
          nodejs
          git
        ]
      }
  '';

  passthru.extractor = rustPlatform.buildRustPackage {
    pname = "moonwave-extractor";
    inherit (finalAttrs) version src;
    __structuredAttrs = true;

    sourceRoot = "${finalAttrs.src.name}/extractor";

    cargoHash = "sha256-AX6otL0rJKlHWSz0hEtw/7Oy1rfywqHuZRaPx5jX/TA=";

    meta = {
      description = "Extractor for moonwave to extract documentation from Lua source comments";
      license = lib.licenses.mpl20;
      mainProgram = "moonwave-extractor";
    };
  };

  meta = {
    description = "Generate documentation from comments in Lua source code";
    # Source repo has two different licenses, mpl20 and mit.
    license = [
      lib.licenses.mpl20
      lib.licenses.mit
    ];
    homepage = "https://eryn.io/moonwave/";
    changelog = "https://github.com/evaera/moonwave/releases/tag/${finalAttrs.src.tag}";
    mainProgram = "moonwave";
    platforms = [
      "x86_64-linux"
      "aarch64-linux"
      "aarch64-darwin"
    ];
    maintainers = with lib.maintainers; [ jerryx77 ];
  };
})
