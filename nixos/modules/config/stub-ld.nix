{ config, lib, pkgs, ... }:

let
  inherit (lib) optionalString mkOption types mdDoc mkIf mkDefault;

  cfg = config.environment.stub-ld;

  message = ''
    NixOS cannot run dynamically linked executables intended for generic
    linux environments out of the box. For more information, see:
    https://nix.dev/permalink/stub-ld
  '';

  stub-ld-for = pkgsArg: messageArg: pkgsArg.pkgsStatic.runCommandCC "stub-ld" {
    nativeBuildInputs = [ pkgsArg.unixtools.xxd ];
    inherit messageArg;
  } ''
    printf "%s" "$messageArg" | xxd -i -n message >main.c
    cat <<EOF >>main.c
    #include <stdio.h>
    int main(int argc, char * argv[]) {
      fprintf(stderr, "Could not start dynamically linked executable: %s\n", argv[0]);
      fwrite(message, sizeof(unsigned char), message_len, stderr);
      return 127; // matches behavior of bash and zsh without a loader. fish uses 139
    }
    EOF
    $CC -Os main.c -o $out
  '';

  pkgs32 = pkgs.pkgsi686Linux;

  stub-ld = stub-ld-for pkgs message;
  stub-ld32 = stub-ld-for pkgs32 message;
in {
  options = {
    environment.stub-ld = {
      enable = mkOption {
        type = types.bool;
        default = true;
        example = false;
        description = mdDoc ''
          Install a stub ELF loader to print an informative error message
          in the event that a user attempts to run an ELF binary not
          compiled for NixOS.
        '';
      };
    };
  };

  config = mkIf cfg.enable {
    environment.ldso = mkDefault stub-ld;
    environment.ldso32 = mkIf pkgs.stdenv.isx86_64 (mkDefault stub-ld32);
  };

  meta.maintainers = with lib.maintainers; [ tejing ];
}
