{ stdenvNoCC, lib, src, version, makeWrapper, coreutils, findutils, gnugrep, systemd }:

stdenvNoCC.mkDerivation {
  name = "distrobuilder-nixos-generator";

  inherit src version;

  patches = [
    ./nixos-generator.patch
  ];

  dontBuild = true;
  nativeBuildInputs = [ makeWrapper ];

  installPhase = ''
    install -D -m 0555 distrobuilder/lxc.generator $out/lib/systemd/system-generators/lxc
    wrapProgram $out/lib/systemd/system-generators/lxc --prefix PATH : ${lib.makeBinPath [coreutils findutils gnugrep systemd]}:${systemd}/lib/systemd
  '';
}
