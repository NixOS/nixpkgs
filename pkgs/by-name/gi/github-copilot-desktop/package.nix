{
  lib,
  stdenv,
  fetchurl,
  zstd,
}:

let
  inherit (stdenv.hostPlatform) system;
  throwSystem = throw "github-copilot-desktop: arch ${system} not supported";
in
stdenv.mkDerivation (finalAttrs: {
  pname = "github-copilot-desktop";
  version = "1.0.21";

  strictDeps = true;
  __structuredAttrs = true;

  src =
    if stdenv.hostPlatform.isLinux then
      let
        arch =
          {
            x86_64-linux = "x64";
            aarch64-linux = "arm64";
          }
          .${system} or throwSystem;
      in
      fetchurl {
        url = "https://github.com/github/app/releases/download/v${finalAttrs.version}/GitHub-Copilot-linux-${arch}.deb";
        hash =
          {
            x86_64-linux = "sha256-C0ssWQ/rYweLgGrzevTmMhg1I4AyM4MVo9pT2qgTCFo=";
            aarch64-linux = "sha256-bp6Q4ZRL5q175e60VOc2xkx7s2dyZF33SC08+SJnXgM=";
          }
          .${system} or throwSystem;
      }
    else if stdenv.hostPlatform.isDarwin then
      let
        arch =
          {
            x86_64-darwin = "x64";
            aarch64-darwin = "arm64";
          }
          .${system} or throwSystem;
      in
      fetchurl {
        url = "https://github.com/github/app/releases/download/v${finalAttrs.version}/GitHub-Copilot-darwin-${arch}.tar.gz";
        hash =
          {
            x86_64-darwin = "sha256-Ve+x3X76oYZMgXbOmZx2cDyRcowR57Rl/ouPlKP7JMs=";
            aarch64-darwin = "sha256-WrMc6NLZFRDAnSfmVOKBMSafr2/c/abEPOe/VFcnfHI=";
          }
          .${system} or throwSystem;
      }
    else
      throwSystem;

  dontUnpack = true;
  dontBuild = true;

  nativeBuildInputs = lib.optionals stdenv.hostPlatform.isLinux [ zstd ];

  installPhase =
    if stdenv.hostPlatform.isLinux then
      ''
        tmpdir=$(mktemp -d)
        ar x "$src" --output="$tmpdir"
        ${zstd}/bin/zstd -d "$tmpdir/data.tar.zst" -o "$tmpdir/data.tar"
        mkdir -p "$out"
        tar xf "$tmpdir/data.tar" -C "$out" ./usr
        mkdir -p "$out/bin"
        ln -s "$out/usr/bin/github" "$out/bin/github"
        ln -s "$out/usr/bin/git-credential-copilot" "$out/bin/git-credential-copilot"
      ''
    else
      ''
        mkdir -p "$out/Applications" "$out/bin"
        tar xzf "$src" -C "$out/Applications"
        ln -s "$out/Applications/GitHub Copilot.app/Contents/MacOS/github" "$out/bin/github"
        ln -s "$out/Applications/GitHub Copilot.app/Contents/MacOS/git-credential-copilot" "$out/bin/git-credential-copilot"
      '';

  meta = {
    description = "GitHub Copilot app is an agent-native desktop experience for agent-driven development";
    downloadPage = "https://github.com/github/app/releases";
    homepage = "https://github.com/features/ai/github-app";
    license = lib.licenses.unfree;
    maintainers = [ ];
    mainProgram = "github";
    platforms = [
      "x86_64-linux"
      "aarch64-linux"
      "x86_64-darwin"
      "aarch64-darwin"
    ];
    sourceProvenance = [ lib.sourceTypes.binaryNativeCode ];
  };
})
