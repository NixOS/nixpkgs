{
  lib,
  rustPlatform,
  fetchFromGitHub,
  nix-update-script,
  versionCheckHook,
}:

rustPlatform.buildRustPackage (finalAttrs: {
  pname = "leaves";
  version = "0.2.0";
  __structuredAttrs = true;

  src = fetchFromGitHub {
    owner = "patonw";
    repo = "leaves";
    tag = "v${finalAttrs.version}";
    hash = "sha256-aTIC9n4NpSW/R/e9Ihn3Oy5Vp36E1t1Ou4cHDUnKrME=";
  };

  cargoHash = "sha256-W1RWE08HXDhgejWcnUKI6/WTk9CAU6wayrNNl87rvMw=";

  nativeInstallCheckInputs = [ versionCheckHook ];
  doInstallCheck = true;
  passthru.updateScript = nix-update-script {
    extraArgs = [
      "--version-regex"
      "^v([0-9.]+)$"
    ];
  };

  meta = {
    mainProgram = "leaves";
    description = "A text-mode disk usage visualization utility";
    longDescription = ''
      Leaves is a disk usage analyzer inspired by WinDirStat and QDirStat.

      It shows files and directories in a hierarchy of nested rectangles.
      The area of a rectangle is proportional to its size.
      A 200 MB file will have twice the size as a sibling with 100 MB.
      The parent directory will have about 3 times the area of the smaller file.
    '';
    homepage = "https://github.com/patonw/leaves";
    downloadPage = "https://github.com/patonw/leaves/releases#release-v${finalAttrs.version}";
    changelog = "https://github.com/patonw/leaves/releases/tag/${finalAttrs.src.tag}";
    license = lib.licenses.mit;
    sourceProvenance = with lib.sourceTypes; [ fromSource ];
    identifiers = {
      cpeParts = lib.meta.cpeFullVersionWithVendor "patonw" finalAttrs.version;
      purlParts = {
        type = "github";
        spec = "patonw/leaves@v${finalAttrs.version}";
      };
    };
    platforms = lib.platforms.all;
    maintainers = with lib.maintainers; [ KristijanZic ];
  };
})
