{ lib, pkgs, ... }:
# This needs to be a VM test because the FUSE kernel module can't be used inside of a derivation in the Nix sandbox.
# This test also exercises the LZFSE support in darling-dmg.
let
  # The last kitty release which is stored on an HFS+ filesystem inside the disk image
  test-dmg-file = pkgs.fetchurl {
    url = "https://github.com/kovidgoyal/kitty/releases/download/v0.17.4/kitty-0.17.4.dmg";
    hash = "sha256-m+c5s8fFrgUc0xQNI196WplYBZq9+lNgems5haZUdvA=";
  };
in
{
  name = "darling-dmg";
  meta.maintainers = with lib.maintainers; [ Luflosi ];

  nodes.machine = { };

  testScript = ''
    start_all()

    machine.succeed("mkdir mount-point")
    machine.succeed("'${pkgs.darling-dmg}/bin/darling-dmg' '${test-dmg-file}' mount-point")

    # Crude way to verify the contents
    # Taken from https://stackoverflow.com/questions/545387/linux-compute-a-single-hash-for-a-given-folder-contents
    # This could be improved. It does not check symlinks for example.
    hash = machine.succeed("""
      (find mount-point -type f -print0  | sort -z | xargs -0 sha256sum; \
       find mount-point \( -type f -o -type d \) -print0 | sort -z | \
         xargs -0 stat -c '%n %a') \
      | sha256sum
    """).strip()
    assert hash == "00e61c2ef171093fbf194e420c17bb84bcdb823238d70eb46e375bab2427cc21  -", f"The disk image contents differ from what was expected (was {hash})"
  '';
}
