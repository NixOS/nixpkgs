{
  lib,
  stdenv,
  runCommand,
  replaceVarsWith,
  coreutils,
}:

let
  name = "service-wrapper-${version}";
  version = "19.04"; # Akin to Ubuntu Release
in
runCommand name
  {
    script = replaceVarsWith {
      src = ./service-wrapper.sh;
      isExecutable = true;
      replacements = {
        inherit (stdenv) shell;
        inherit coreutils;
      };
    };

    meta = with lib; {
      description = "Convenient wrapper for the systemctl commands, borrow from Ubuntu";
      mainProgram = "service";
      license = licenses.gpl2Plus;
      platforms = platforms.linux;
      maintainers = with maintainers; [ DerTim1 ];
      # Shellscript has been modified but upstream source is: https://git.launchpad.net/ubuntu/+source/init-system-helpers
    };
  }
  ''
    mkdir -p $out/bin
    ln -s $out/bin $out/sbin
    cp $script $out/bin/service
    chmod a+x $out/bin/service
  ''
