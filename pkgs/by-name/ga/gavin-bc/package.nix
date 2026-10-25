{
  lib,
  stdenv,
  fetchFromGitHub,
  nix-update-script,
  versionCheckHook,
}:
stdenv.mkDerivation (finalAttrs: {
  pname = "gavin-bc";
  version = "7.1.0";

  __structuredAttrs = true;
  strictDeps = true;

  src = fetchFromGitHub {
    owner = "gavinhoward";
    repo = "bc";
    rev = finalAttrs.version;
    hash = "sha256-bIQk0HzUzL1Ju4+iDpFj1n+GKCj9a3AUAbYA3yX5TNg=";
  };

  # Upstream's safe-install.sh sets umask 077 before creating the dc -> bc
  # symlink. Darwin records symlink permissions, making the link unreadable for
  # non-root. This recreates the link with the default umask 022.
  postInstall = ''
    ln -sf bc $out/bin/dc
  '';

  nativeInstallCheckInputs = [ versionCheckHook ];
  versionCheckProgram = "${placeholder "out"}/bin/bc";
  doInstallCheck = true;

  passthru.updateScript = nix-update-script { };

  meta = {
    homepage = "https://github.com/gavinhoward/bc";
    description = "Gavin Howard's BC calculator implementation";
    changelog = "https://github.com/gavinhoward/bc/blob/${finalAttrs.version}/NEWS.md";
    license = lib.licenses.bsd2;
    maintainers = with lib.maintainers; [ delafthi ];
    platforms = lib.platforms.unix;
  };
})
