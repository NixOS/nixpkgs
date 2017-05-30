{ stdenv, fetchurl }:

stdenv.mkDerivation rec {
  name = "go-jira-0.1.14";

  meta = {
    description = "simple command line client for Atlassian's Jira service written in Go";
    homepage = "https://github.com/Netflix-Skunkworks/go-jira";
    licence = stdenv.lib.licenses.asl20;
    platforms = stdenv.lib.platforms.linux;
  };

  src = fetchurl {
    url = https://github.com/Netflix-Skunkworks/go-jira/releases/download/v0.1.14/jira-linux-amd64;
    sha256 = "1z09alpc6dzlxw520k23683rwnsk8mw3bi52y76ijc5rq19mhznn";
  };

  phases = [ "installPhase" ];

  # Taken from https://github.com/NixOS/patchelf/issues/66#issuecomment-267743051
  installPhase = ''
    # Create bin
    mkdir -p $out/bin
    # Copy to bin
    cp $src $out/bin/jira.wrapped
    # Write out to script
    echo "#!/usr/bin/env bash" >> $out/bin/jira
    echo $(< $NIX_CC/nix-support/dynamic-linker) $out/bin/jira.wrapped \"\$@\" >> $out/bin/jira
    # Make executable
    chmod +x $out/bin/jira
  '';
}
