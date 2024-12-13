{
  resholve,
  lib,
  coreutils,
  nix,
  fetchFromGitHub,
  writeText,
}:

# resholve does not yet support `finalAttrs` call pattern hence `rec`
# https://github.com/abathur/resholve/issues/107
resholve.mkDerivation rec {
  pname = "nix-direnv";
  version = "3.0.6";

  src = fetchFromGitHub {
    owner = "nix-community";
    repo = "nix-direnv";
    rev = version;
    hash = "sha256-oNqhPqgQT92yxbKmcgX4F3e2yTUPyXYG7b2xQm3TvQw=";
  };

  installPhase = ''
    runHook preInstall
    install -m400 -D direnvrc $out/share/nix-direnv/direnvrc
    runHook postInstall
  '';

  solutions = {
    default = {
      scripts = [ "share/nix-direnv/direnvrc" ];
      interpreter = "none";
      inputs = [ coreutils ];
      fake = {
        builtin = [
          "PATH_add"
          "direnv_layout_dir"
          "has"
          "log_error"
          "log_status"
          "watch_file"
        ];
        function = [
          # not really a function - this is in an else branch for macOS/homebrew that
          # cannot be reached when built with nix
          "shasum"
        ];
        external = [
          # We want to reference the ambient Nix when possible, and have custom logic
          # for the fallback
          "nix"
        ];
      };
      keep = {
        "$cmd" = true;
        "$direnv" = true;

        # Nix fallback implementation
        "$_nix_direnv_nix" = true;
        "$ambient_nix" = true;
        "$NIX_DIRENV_FALLBACK_NIX" = true;
      };
      prologue =
        (writeText "prologue.sh" ''
          NIX_DIRENV_FALLBACK_NIX=''${NIX_DIRENV_FALLBACK_NIX:-${lib.getExe nix}}
        '').outPath;
    };
  };

  meta = {
    description = "Fast, persistent use_nix implementation for direnv";
    homepage = "https://github.com/nix-community/nix-direnv";
    license = lib.licenses.mit;
    platforms = lib.platforms.unix;
    maintainers = with lib.maintainers; [
      mic92
      bbenne10
    ];
  };
}
