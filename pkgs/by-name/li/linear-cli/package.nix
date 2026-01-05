{
  lib,
  stdenv,
  buildPackages,
  fetchurl,
  buildFHSEnv,
  installShellFiles,
  versionCheckHook,
}:

let
  pname = "linear-cli";
  version = "1.9.1";

  system = stdenv.hostPlatform.system;

  platformData = {
    aarch64-darwin = {
      suffix = "aarch64-apple-darwin";
      hash = "sha256-ZfT+9DdLT9e1GtQSlu2J3fHFQYnUEzijSHNYpElfaWs=";
    };
    x86_64-darwin = {
      suffix = "x86_64-apple-darwin";
      hash = "sha256-48oKJytD8iUzKugMaTUM+aJKB9Hg1C+3jF6kaW6wQF0=";
    };
    aarch64-linux = {
      suffix = "aarch64-unknown-linux-gnu";
      hash = "sha256-FZ1zfQqIoX9IXq28Ti5AN+omqwwJGYsAtVbld3pSgN8=";
    };
    x86_64-linux = {
      suffix = "x86_64-unknown-linux-gnu";
      hash = "sha256-+LEDaEK9WIDPBfR2krTwnAq7Oq01LxjL9O6V3z7C87s=";
    };
  };

  platform = platformData.${system} or (throw "${pname}: no upstream binary available for ${system}");

  src = fetchurl {
    url = "https://github.com/schpet/linear-cli/releases/download/v${version}/linear-${platform.suffix}.tar.xz";
    hash = platform.hash;
  };

  sourceRoot = "linear-${platform.suffix}";

  common = {
    nativeBuildInputs = [ installShellFiles ];
    nativeInstallCheckInputs = [ versionCheckHook ];
    doInstallCheck = true;
  };

  completionsInstall =
    let
      exe =
        if stdenv.buildPlatform.canExecute stdenv.hostPlatform then
          "$out/bin/linear"
        else
          lib.getExe buildPackages.linear-cli;
    in
    lib.optionalString (stdenv.buildPlatform.canExecute stdenv.hostPlatform) ''
      installShellCompletion --cmd linear \
        --bash <(${exe} completions bash) \
        --fish <(${exe} completions fish) \
        --zsh <(${exe} completions zsh)
    '';

  meta = {
    description = "CLI for Linear issue tracker - list, start, and create PRs for issues";
    homepage = "https://github.com/schpet/linear-cli";
    changelog = "https://github.com/schpet/linear-cli/blob/main/CHANGELOG.md";
    license = lib.licenses.isc;
    maintainers = with lib.maintainers; [
      iamanaws
    ];
    mainProgram = "linear";
    sourceProvenance = with lib.sourceTypes; [ binaryNativeCode ];
    platforms = builtins.attrNames platformData;
  };

  upstream = stdenv.mkDerivation {
    pname = "${pname}-upstream";
    inherit
      version
      src
      sourceRoot
      meta
      ;

    dontStrip = true;
    dontFixup = true;

    installPhase = ''
      runHook preInstall
      install -Dm755 linear $out/libexec/linear
      runHook postInstall
    '';
  };
in
if stdenv.hostPlatform.isLinux then
  buildFHSEnv (
    common
    // {
      inherit pname version meta;

      executableName = "linear";
      runScript = "${upstream}/libexec/linear";

      targetPkgs = pkgs: [
        pkgs.glibc
        pkgs.libgcc
      ];

      extraInstallCommands = completionsInstall;

      passthru = {
        inherit src;
        updateScript = ./update.sh;
      };
    }
  )
else
  stdenv.mkDerivation (
    common
    // {
      inherit
        pname
        version
        meta
        src
        ;

      dontUnpack = true;

      dontStrip = true;
      dontFixup = true;

      installPhase = ''
        runHook preInstall
        mkdir -p $out/bin
        ln -s ${upstream}/libexec/linear $out/bin/linear
        runHook postInstall
      '';

      postInstall = completionsInstall;

      passthru.updateScript = ./update.sh;
    }
  )
