# This module adds a scripted iPXE entry to the GRUB boot menu.

{
  config,
  lib,
  pkgs,
  ...
}:

let
  scripts = builtins.attrNames config.boot.loader.grub.ipxe;

  grubEntry = name: ''
    menuentry "iPXE - ${name}" {
      linux16 @bootRoot@/ipxe.lkrn
      initrd16 @bootRoot@/${name}.ipxe
    }

  '';

  scriptFile =
    name:
    let
      value = builtins.getAttr name config.boot.loader.grub.ipxe;
    in
    if builtins.typeOf value == "path" then value else builtins.toFile "${name}.ipxe" value;
in
{
  options = {
    boot.loader.grub.ipxe = lib.mkOption {
      type = lib.types.attrsOf (lib.types.either lib.types.path lib.types.str);
      description = ''
        Set of iPXE scripts available for
        booting from the GRUB boot menu.
      '';
      default = { };
      example = lib.literalExpression ''
        { demo = '''
            #!ipxe
            dhcp
            chain http://boot.ipxe.org/demo/boot.php
          ''';
        }
      '';
    };
  };

  config = lib.mkIf (builtins.length scripts != 0) {

    boot.loader.grub.extraEntries = toString (map grubEntry scripts);

    boot.loader.grub.extraFiles =
      {
        "ipxe.lkrn" = "${pkgs.ipxe}/ipxe.lkrn";
      }
      // builtins.listToAttrs (
        map (name: {
          name = name + ".ipxe";
          value = scriptFile name;
        }) scripts
      );
  };

}
