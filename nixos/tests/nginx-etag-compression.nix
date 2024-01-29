import ./make-test-python.nix {
  name = "nginx-etag-compression";

  nodes.machine = { pkgs, lib, ... }: {
    services.nginx = {
      enable = true;
      recommendedGzipSettings = true;
      virtualHosts.default = {
        root = pkgs.runCommandLocal "testdir" {} ''
          mkdir "$out"
          cat > "$out/index.html" <<EOF
          Hello, world!
          Hello, world!
          Hello, world!
          Hello, world!
          Hello, world!
          Hello, world!
          Hello, world!
          Hello, world!
          EOF
          ${pkgs.gzip}/bin/gzip -k "$out/index.html"
        '';
      };
    };
  };

  testScript = { nodes, ... }: ''
    machine.wait_for_unit("nginx")
    machine.wait_for_open_port(80)

    etag_plain = machine.succeed("curl -s -w'%header{etag}' -o/dev/null -H 'Accept-encoding:' http://127.0.0.1/")
    etag_gzip = machine.succeed("curl -s -w'%header{etag}' -o/dev/null -H 'Accept-encoding:gzip' http://127.0.0.1/")

    with subtest("different representations have different etags"):
      assert etag_plain != etag_gzip, f"etags should differ: {etag_plain} == {etag_gzip}"

    with subtest("etag for uncompressed response is reproducible"):
      etag_plain_repeat = machine.succeed("curl -s -w'%header{etag}' -o/dev/null -H 'Accept-encoding:' http://127.0.0.1/")
      assert etag_plain == etag_plain_repeat, f"etags should be the same: {etag_plain} != {etag_plain_repeat}"

    with subtest("etag for compressed response is reproducible"):
      etag_gzip_repeat = machine.succeed("curl -s -w'%header{etag}' -o/dev/null -H 'Accept-encoding:gzip' http://127.0.0.1/")
      assert etag_gzip == etag_gzip_repeat, f"etags should be the same: {etag_gzip} != {etag_gzip_repeat}"
  '';
}
