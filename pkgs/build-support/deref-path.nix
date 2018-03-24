{ runCommand }:
{ name, src }:
runCommand name {} "cp -aL ${toString src}/ $out/"
