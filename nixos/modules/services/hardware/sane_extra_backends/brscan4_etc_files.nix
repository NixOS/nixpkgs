{ stdenv, lib, brscan4, netDevices ? [] }:

/*

Testing
-------

No net devices:

~~~
nix-shell -E 'with import <nixpkgs> { }; brscan4-etc-files'
~~~

Two net devices:

~~~
nix-shell -E 'with import <nixpkgs> { }; brscan4-etc-files.override{netDevices=[{name="a"; model="MFC-7860DW"; nodename="BRW0080927AFBCE";} {name="b"; model="MFC-7860DW"; ip="192.168.1.2";}];}'
~~~

*/

with lib; 

let

  addNetDev = nd: ''
    brsaneconfig4 -a \
    name="${nd.name}" \
    model="${nd.model}" \
    ${if (hasAttr "nodename" nd && nd.nodename != null) then
      ''nodename="${nd.nodename}"'' else
      ''ip="${nd.ip}"''}'';
  addAllNetDev = xs: concatStringsSep "\n" (map addNetDev xs);
in

stdenv.mkDerivation rec {

  name = "brscan4-etc-files-0.4.3-3";
  src = "${brscan4}/opt/brother/scanner/brscan4";

  nativeBuildInputs = [ brscan4 ];

  configurePhase = ":";

  buildPhase = ''
    TARGET_DIR="$out/etc/opt/brother/scanner/brscan4"
    mkdir -p "$TARGET_DIR"
    cp -rp "./models4" "$TARGET_DIR"
    cp -rp "./Brsane4.ini" "$TARGET_DIR"
    cp -rp "./brsanenetdevice4.cfg" "$TARGET_DIR"

    export BRSANENETDEVICE4_CFG_FILENAME="$TARGET_DIR/brsanenetdevice4.cfg"

    printf '${addAllNetDev netDevices}\n'

    ${addAllNetDev netDevices}
  '';

  installPhase = ":";

  dontStrip = true;
  dontPatchELF = true;

  meta = {
    description = "Brother brscan4 sane backend driver etc files";
    homepage = http://www.brother.com;
    platforms = stdenv.lib.platforms.linux;
    license = stdenv.lib.licenses.unfree;
    maintainers = with stdenv.lib.maintainers; [ jraygauthier ];
  };
}
