{
  secrets.store.greeting = {
    files.greeting = { };
    generate =
      pkgs:
      pkgs.writeShellScript "gen-greeting" ''
        echo "Hewwo world :3c" > $out/greeting
      '';
  };
}
