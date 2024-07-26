{ resholve, lib, coreutils, direnv, nix, fetchFromGitHub }:

# resholve does not yet support `finalAttrs` call pattern hence `rec`
# https://github.com/abathur/resholve/issues/107
resholve.mkDerivation rec {
  pname = "nix-direnv";
  version = "3.0.4";

  src = fetchFromGitHub {
    owner = "nix-community";
    repo = "nix-direnv";
    rev = version;
    hash = "sha256-3Fkat0HWU/hdQKwJYx5KWVzX8sVbGtFTon6G6/F9zFk=";
  };

  # skip min version checks which are redundant when built with nix
  postPatch = ''
    sed -i 1iNIX_DIRENV_SKIP_VERSION_CHECK=1 direnvrc
  '';

  installPhase = ''
    runHook preInstall
    install -m400 -D direnvrc $out/share/nix-direnv/direnvrc
    runHook postInstall
  '';

  solutions = {
    default = {
      scripts = [ "share/nix-direnv/direnvrc" ];
      interpreter = "none";
      inputs = [ coreutils nix ];
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
      };
      keep = {
        "$cmd" = true;
        "$direnv" = true;
      };
      execer = [
        "cannot:${direnv}/bin/direnv"
        "cannot:${nix}/bin/nix"
      ];
    };
  };

  meta = {
    description = "A fast, persistent use_nix implementation for direnv";
    homepage    = "https://github.com/nix-community/nix-direnv";
    license     = lib.licenses.mit;
    platforms   = lib.platforms.unix;
    maintainers = with lib.maintainers; [ mic92 bbenne10 ];
  };
}
