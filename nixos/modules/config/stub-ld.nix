{
  config,
  lib,
  pkgs,
  ...
}:

let
  inherit (lib)
    optionalString
    mkOption
    types
    mkIf
    mkDefault
    elem
    replaceStrings
    ;

  cfg = config.environment.stub-ld;

  messagePre = "Could not start dynamically linked executable: ";
  messagePost = "\n" + ''
    NixOS cannot run dynamically linked executables intended for generic
    linux environments out of the box. For more information, see:
    https://nix.dev/permalink/stub-ld
  '';

  escapeCString = s: "\"" + replaceStrings [ "\\" "\"" "\n" ] [ "\\\\" "\\\"" "\\n" ] s + "\"";

  src = builtins.toFile "stub-ld.c" ''
    #include <stdio.h>

    int main(int argc, char **argv) {
      fputs(${escapeCString messagePre}, stderr);
      fputs(argv[0], stderr);
      fputs(${escapeCString messagePost}, stderr);
      return 127; // matches behavior of bash and zsh without a loader. fish uses 139
    }
  '';

  inherit (pkgs.minimal-bootstrap) stage0-posix;
  stub-ld-for =
    system:
    let
      platform = lib.systems.elaborate system;
    in
    pkgs.runCommandCC "stub-ld"
      {
        inherit (stage0-posix)
          M2
          M1
          hex2
          m2libc
          ;
        inherit
          (pkgs.minimal-bootstrap.stage0-posix.overrideScope (self: super: { hostPlatform = platform; }))
          m2libcArch
          baseAddress
          ;
        endianFlag = if platform.isLittleEndian then "--little-endian" else "--big-endian";
        archDefine =
          {
            x86_64-linux = "__x86_64__";
            i686-linux = "__i386__";
            aarch64-linux = "__aarch64__";
          }
          .${system};
      }
      ''
        cpp -P -undef -nostdinc \
          -isystem $m2libc \
          -D __M2__ \
          -D $archDefine \
          ${src} \
          -o stub-ld.c

        $M2 --architecture $m2libcArch \
          -f stub-ld.c \
          -o stub-ld.M1

        $M1 --architecture $m2libcArch $endianFlag \
          -f $m2libc/$m2libcArch/''${m2libcArch}_defs.M1 \
          -f $m2libc/$m2libcArch/libc-full.M1 \
          -f stub-ld.M1 \
          -o stub-ld.hex2

        $hex2 --architecture $m2libcArch $endianFlag --base-address $baseAddress \
          -f $m2libc/$m2libcArch/ELF-$m2libcArch.hex2 \
          -f stub-ld.hex2 \
          -o $out
      '';

  stub-ld =
    if elem pkgs.stdenv.hostPlatform.system stage0-posix.platforms then
      stub-ld-for pkgs.stdenv.hostPlatform.system
    else
      pkgs.pkgsStatic.runCommandCC "stub-ld" { } "$CC ${src} -o $out";
  stub-ld32 = stub-ld-for "i686-linux";
in
{
  options = {
    environment.stub-ld = {
      enable = mkOption {
        type = types.bool;
        default = true;
        example = false;
        description = ''
          Install a stub ELF loader to print an informative error message
          in the event that a user attempts to run an ELF binary not
          compiled for NixOS.
        '';
      };
    };
  };

  config = mkIf cfg.enable {
    environment.ldso = mkDefault stub-ld;
    environment.ldso32 = mkIf pkgs.stdenv.hostPlatform.isx86_64 (mkDefault stub-ld32);
  };

  meta.maintainers = with lib.maintainers; [ tejing ];
}
