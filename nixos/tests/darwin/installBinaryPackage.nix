{ pkgs, runTest }:
let
  mkCheck =
    package-path: expected-hash:
    let
      package = pkgs.callPackage package-path { };
    in
    {
      name = "check ${package.pname}";
      nodes = {
        machine = {
          environment.systemPackages = [
            package
          ];
        };
      };

      testScript =
        # python
        ''
          # nix hash path --sri  $path_to_installed
          # then check hash.
          # output = machine.succeed("ls /nix/store/")
          # print(output)

          path = "${package}"
          output = machine.succeed(f"nix-hash --type sha256 --sri {path}")
          EXPECTED_HASH = "${expected-hash}"
          second_line_prefix_len = len("AssertionError: Expected:") - len("was:")
          assert output.strip() == EXPECTED_HASH, f"Expected: {EXPECTED_HASH}\n{ ' ' * second_line_prefix_len }was: {output.strip()}"
        '';
    };
in
{
  dmg = runTest (
    mkCheck ./dmg-based-package.nix "sha256-Jfukle/bUwy0X/okdL8x1HxmmF7+AVjNjuwyEbqkY90="
  );
  pkg = runTest (
    mkCheck ./pkg-based-package.nix "sha256-ZD1Zycaj69daNaC87cz9NEk9HBT5fhHtjHRmu2HeE10="
  );
  zip = runTest (mkCheck ./zip-based-package.nix "");
  tar-xz = runTest (
    mkCheck ./tar.xz-based-package.nix "sha256-uO38VmlD9rKjGazOSfFTiw3jLBZUHyNq5j+ohKvaQgM="
  );
}
