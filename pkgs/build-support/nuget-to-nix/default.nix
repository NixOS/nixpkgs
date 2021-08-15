{ runCommandNoCC }:

runCommandNoCC "nuget-to-nix" { preferLocalBuild = true; } ''
  install -D -m755 ${./nuget-to-nix.sh} $out/bin/nuget-to-nix
''
