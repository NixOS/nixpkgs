{ lib, pkgs, ... }:
let
  mkTestZim =
    name:
    pkgs.runCommandLocal "${name}.zim"
      {
        nativeBuildInputs = [ pkgs.zim-tools ];
      }
      ''
        ${lib.getExe' pkgs.zim-tools "zimwriterfs"} \
          --name "${name}" \
          --title 'NixOS kiwix-serve Test' \
          --description 'NixOS test of kiwix-serve' \
          --creator Nixpkgs \
          --publisher Nixpkgs \
          --language eng \
          --welcome index.html \
          --illustration icon.png \
          ${./html} \
          $out
      '';

  # Test files must have different names or kiwix-serve will only serve one of them
  testZimStore = mkTestZim "test-store";
  testZimOutside = mkTestZim "test-outside";
in
{
  name = "kiwix-serve";
  meta.maintainers = with lib.maintainers; [ MysteryBlokHed ];

  nodes = {
    machine = {
      systemd.services.copy-zim-file = {
        description = "Copy test ZIM file to host system to test paths outside of store";
        wantedBy = [ "multi-user.target" ];
        before = [ "kiwix-serve.service" ];
        requiredBy = [ "kiwix-serve.service" ];

        serviceConfig = {
          Type = "oneshot";
        };

        script = ''
          mkdir -p /var/lib/kiwix-serve
          cp ${testZimOutside} /var/lib/kiwix-serve/test-outside.zim
        '';
      };

      services.kiwix-serve = {
        enable = true;
        port = 8080;
        library = {
          test-store = testZimStore;
          test-outside = "/var/lib/kiwix-serve/test-outside.zim";
        };
      };
    };
  };

  testScript = ''
    machine.wait_for_unit("kiwix-serve.service")
    machine.wait_for_open_port(8080)
    machine.wait_until_succeeds("curl --fail --silent --head http://localhost:8080")

    # ZIM file in store
    test_content = machine.succeed("curl --fail --silent --location http://localhost:8080/content/test-store")
    print(test_content)
    assert "NixOS test of kiwix-serve" in test_content, "kiwix-serve did not provide the expected page for the store ZIM file"

    # ZIM file outside of store
    test_content = machine.succeed("curl --fail --silent --location http://localhost:8080/content/test-outside")
    print(test_content)
    assert "NixOS test of kiwix-serve" in test_content, "kiwix-serve did not provide the expected page for the out-of-store ZIM file"
  '';
}
