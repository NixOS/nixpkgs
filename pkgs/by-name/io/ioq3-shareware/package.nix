{
  ioquake3,
  fetchurl,
  runCommand,
  lib,
}:
let
  demo = fetchurl {
    url = "https://ftp.gwdg.de/pub/misc/ftp.idsoftware.com/idstuff/quake3/linux/linuxq3ademo-1.11-6.x86.gz.sh";
    hash = "sha256-ZN7j9ptueS0dpP4KyY/tx+seN+oQJ/tgmp+t0GFQpOw=";
  };
  apoint = fetchurl {
    url = "https://ftp.gwdg.de/pub/misc/ftp.idsoftware.com/idstuff/quake3/linux/linuxq3apoint-1.32b-3.x86.run";
    hash = "sha256-w2EyxVVrNeAZUPHpxkYjUDOlEw+HrXdrorx77PT08YY=";
  };
  assets = runCommand "ioq3-assets" { } ''
    mkdir -p $out/share/ioquake3
    tail +356 ${apoint} | tar -zx baseq3
    tail +165 ${demo} | tar -zx -C baseq3 --strip-components=1 demoq3/pak0.pk3
    mv baseq3 $out/share/ioquake3/baseq3
  '';
in
ioquake3.overrideAttrs (old: {
  pname = "ioq3-shareware";
  postInstall =
    old.postInstall
    + ''
      ln -s ${assets}/share/ioquake3/baseq3/* $out/share/ioquake3/baseq3/
    '';
  meta = {
    license = {
      fullName = "QUAKE III: ARENA Point Release EULA";
      url = "https://lvlworld.com/text/txt/point-release-EULA/essential";
      free = false;
    };
    description = "ioquake3 with shareware assets";
    maintainers = with lib.maintainers; [ matthewcroughan ];
  };
})
