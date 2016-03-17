{ stdenv, pkgs, ... }:

let
  rulesTarget = "lib/udev/rules.d/50-fc-disk-alias.rules";

in
stdenv.mkDerivation {
  name = "fc-udev";
  src = ./src;
  propagatedBuildInputs = [ pkgs.utillinux ];
  installPhase = ''
    install -D -m 0755 fc-disk-alias.sh "$out/bin/fc-disk-alias"
    install -D fc-disk-alias.rules "$out/${rulesTarget}"
  '';
  postFixup = ''
    substituteInPlace "$out/${rulesTarget}" --subst-var out
  '';
}
