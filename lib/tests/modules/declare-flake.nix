{ lib, ... }: {
  options.flake = lib.mkOption { type = lib.types.flake; };
}
