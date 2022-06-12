import ./make-test-python.nix ({ pkgs, ... }: {
  name = "kbd-update-search-paths-patch";

  nodes.machine = { pkgs, options, ... }: {
    console = {
      packages = options.console.packages.default ++ [ pkgs.terminus_font ];
    };
  };

  testScript = ''
    command = "${pkgs.kbd}/bin/setfont ter-112n 2>&1"
    (status, out) = machine.execute(command)
    import re
    pattern = re.compile(r".*Unable to find file:.*")
    match = pattern.match(out)
    if match:
        raise Exception("command `{}` failed".format(command))
  '';
})
