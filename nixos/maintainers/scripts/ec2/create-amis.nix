{ stdenv, lib, runtimeShell, coreutils, awscli, jq }:
stdenv.mkDerivation {
  name = "create-nixos-amis";

  dontUnpack = true;

  installPhase =
    ''
      mkdir -p $out/bin
      # Replace the nix-shell shebang with bash:
      cat << EOF > $out/bin/create-nixos-amis
      #!${runtimeShell}
      export PATH="${lib.makeBinPath [coreutils awscli jq]}"
      EOF
      tail -n +3 ${./create-amis.sh} >> $out/bin/create-nixos-amis
      chmod 555 $out/bin/create-nixos-amis
    '';

  meta = with lib; {
    description = "A script to create Amazon Machine Images from NixOS systems";
    platforms = platforms.unix;
  };
}
