{
  lib,
  pkgs,
  ...
}:
{
  name = "owi";

  meta.maintainers = with lib.maintainers; [ ethancedwards8 ];

  nodes.machine = {
    environment.systemPackages = with pkgs; [ owi ];

    environment.etc."owipass.rs".source = pkgs.writeText "owi.rs" ''
      use owi_sym::Symbolic;

      fn mean_one(x: i32, y: i32) -> i32 {
          (x + y)/2
      }

      fn mean_two(x: i32, y: i32) -> i32 {
          (y + x)/2
      }

      fn main() {
          let x = i32::symbol();
          let y = i32::symbol();
          // proving the commutative property of addition!
          owi_sym::assert(mean_one(x, y) == mean_two(x, y))
      }
    '';

    environment.etc."owifail.rs".source = pkgs.writeText "owi.rs" ''
      use owi_sym::Symbolic;

      fn mean_wrong(x: i32, y: i32) -> i32 {
          (x + y) / 2
      }

      fn mean_correct(x: i32, y: i32) -> i32 {
          (x & y) + ((x ^ y) >> 1)
      }

      fn main() {
          let x = i32::symbol();
          let y = i32::symbol();
          owi_sym::assert(mean_wrong(x, y) == mean_correct(x, y))
      }
    '';
  };

  testScript =
    { nodes, ... }:
    ''
      start_all()

      # testing
      machine.succeed("owi rust --fail-on-assertion-only /etc/owipass.rs")
      machine.fail("owi rust --fail-on-assertion-only /etc/owifail.rs")
    '';
}
