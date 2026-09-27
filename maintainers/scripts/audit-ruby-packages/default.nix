let
  pkgs = import ../../.. { };
  lockFileBody = pkgs.lib.concatStringsSep "\n" (
    pkgs.lib.mapAttrsToList (name: props: "    ${name} (${props.version})") (
      pkgs.lib.filterAttrs (name: _props: name != "recurseForDerivations") pkgs.rubyPackages
    )
  );
in
pkgs.runCommand "bundle-audit" { } ''
  mkdir "$out"
  echo 'GEM' > "$out/Gemfile.lock"
  echo '  remote: https://rubygems.org/' >> "$out/Gemfile.lock"
  echo '  specs:' >> "$out/Gemfile.lock"
  echo '${lockFileBody}' >> "$out/Gemfile.lock"
''
