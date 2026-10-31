{
  lib,
  buildNpmPackage,
  callPackage,
  electron,
  fetchFromGitHub,
  makeWrapper,
  nix-update-script,
}:

buildNpmPackage (finalAttrs: {
  pname = "bitburner";
  version = "3.0.1";

  src = fetchFromGitHub {
    owner = "bitburner-official";
    repo = "bitburner-src";
    tag = "v${finalAttrs.version}";
    hash = "sha256-6S3UWDNmpCvkfMscncb+Ca3GTwCiF8cugs30Og5DT6c=";
  };

  npmDepsHash = "sha256-zQQ1PV5NhzD1LJVXUmW6hW479JfZ5qWTnjxfSIz/XVA=";

  __structuredAttrs = true;

  env = {
    ELECTRON_SKIP_BINARY_DOWNLOAD = "1";
  };

  nativeBuildInputs = [
    makeWrapper
  ];

  postPatch = ''
    substituteInPlace webpack.config.js \
      --replace-fail 'require("child_process").execSync("git rev-parse --short HEAD").toString().trim();' '"${finalAttrs.src.tag}"'
  '';

  installPhase = ''
    runHook preInstall

    mkdir -p $out/share/bitburner
    cp -r .app/* $out/share/bitburner
    cp -r ${finalAttrs.passthru.electron}/* $out/share/bitburner

    makeWrapper ${lib.getExe electron} $out/bin/bitburner \
      --add-flags $out/share/bitburner \
      --inherit-argv0

    runHook postInstall
  '';

  passthru = {
    electron = callPackage ./electron.nix { inherit (finalAttrs) src version; };
    updateScript = nix-update-script {
      extraArgs = [
        "--subpackage"
        "electron"
      ];
    };
  };

  meta = {
    description = "Programming-based incremental game that revolves around hacking and cyberpunk themes";
    homepage = "https://github.com/bitburner-official/bitburner-src";
    changelog = "https://github.com/bitburner-official/bitburner-src/releases/tag/${finalAttrs.src.tag}";
    license =
      with lib.licenses;
      AND [
        asl20
        commons-clause
      ];
    maintainers = with lib.maintainers; [ ilkecan ];
    platforms = lib.platforms.linux;
    mainProgram = "bitburner";
  };
})
