import ./make-test-python.nix ({ pkgs, ... }: {
  name = "yq";
  meta = with pkgs.stdenv.lib.maintainers; { maintainers = [ nequissimus ]; };

  nodes.yq = { pkgs, ... }: { environment.systemPackages = with pkgs; [ jq yq ]; };

  testScript = ''
    assert "hello:\n  foo: bar\n" in yq.succeed(
        'echo \'{"hello":{"foo":"bar"}}\' | yq -y .'
    )
  '';
})
