{
  secrets.store.greeting = {
    files.greeting = { };
    generate =
      pkgs:
      pkgs.writeScript "gen-greeting" ''
        #!/bin/sh
        echo "Hewwo world :3c" > $out/greeting
      '';
  };
}
