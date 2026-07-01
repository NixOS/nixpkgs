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
  version = "1.0.9";

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
            x86_64-linux = "sha256-mPOVlmRb72/4hNoJ1CxcDq90UXGPKZJPmwPM9yWRKAk=";
            aarch64-linux = "sha256-XUGcLvFvaKrcXA3uznr7ItxrK+G+jmMigxS5DUCUSnM=";
          }
          .${system};
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
            x86_64-darwin = "sha256-UEB61mCS/GSvLJfKWKcQhdcfgm1n9znhhbv2SYBtutM=";
            aarch64-darwin = "sha256-3jHRpWjXQ0SazKAgOXyQPDuDFbMlXZMMdSrj2j2M2vw=";
          }
          .${system};
      }
    else
      throwSystem;

  dontUnpack = true;
  dontBuild = true;

  nativeBuildInputs = lib.optionals stdenv.hostPlatform.isLinux [ zstd ];

  installPhase =
    if stdenv.hostPlatform.isLinux then
      ''
        mkdir -p $out
        cd $out
        ar x $src
        ${zstd}/bin/zstd -d data.tar.zst -o data.tar
        tar xf data.tar
      ''
    else
      ''
        mkdir -p $out/Applications $out/bin
        tar xzf $src -C $out/Applications
        ln -s "$out/Applications/GitHub Copilot.app/Contents/MacOS/github" $out/bin/github
        ln -s "$out/Applications/GitHub Copilot.app/Contents/MacOS/git-credential-copilot" $out/bin/git-credential-copilot
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
  };
})
