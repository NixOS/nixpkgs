{ config, lib, ... }:

with lib;

{
  options = {
    file = mkOption {
      default = null;
      example = "/dev/sdb1";
      type = types.nullOr (types.listOf types.str);
      description = lib.mdDoc ''
        The name of the file (can be a raw device or a partition) that
        should be used as the decryption key for the encrypted device. If
        not specified, you will be prompted for a passphrase instead.
      '';
    };

    fileSize = mkOption {
      default = null;
      example = 4096;
      type = types.nullOr types.int;
      description = lib.mdDoc ''
        The size of the key file. Use this if only the beginning of the
        key file should be used as a key (often the case if a raw device
        or partition is used as key file). If not specified, the whole
        `keyFile` will be used decryption, instead of just
        the first `keyFileSize` bytes.
      '';
    };

    fileOffset = mkOption {
      default = null;
      example = 4096;
      type = types.nullOr types.int;
      description = lib.mdDoc ''
        The offset of the key file. Use this in combination with
        `size` to use part of a file as key file
        (often the case if a raw device or partition is used as a key file).
        If not specified, the key begins at the first byte of
        `file`.
      '';
    };

    priority = mkOption {
      type = types.int;
      default = 1000;
      description = lib.mdDoc ''
        Order of this location block in relation to the others in keys.
        The semantics are the same as with `lib.mkOrder`. Smaller values have
        a greater priority.
      '';
    };

  };
}

