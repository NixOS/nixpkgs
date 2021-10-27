import ./make-test-python.nix ({ pkgs, ... }: {
  name = "google-cloud-sdk";
  meta = with pkgs.lib.maintainers; { maintainers = [ iammrinal0 ]; };

  machine = { pkgs, ... }: {
    environment.systemPackages = [ pkgs.google-cloud-sdk ];
  };

  testScript = ''
    import json
    assert "${pkgs.google-cloud-sdk.version}" in json.loads(machine.succeed("gcloud version --format json"))["Google Cloud SDK"]
  '';
})
