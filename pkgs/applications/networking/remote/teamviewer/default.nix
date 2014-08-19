{ stdenv, fetchurl, libX11, libXtst, libXext, libXdamage, libXfixes, wine, makeWrapper
, bash, findutils, coreutils }:

assert stdenv.system == "i686-linux";
let
  topath = "${wine}/bin";

  toldpath = stdenv.lib.concatStringsSep ":" (map (x: "${x}/lib") 
    [ stdenv.gcc.gcc libX11 libXtst libXext libXdamage libXfixes wine ]);
in
stdenv.mkDerivation {
  name = "teamviewer-7.0.9377";
  src = fetchurl {
    url = "http://download.teamviewer.com/download/version_7x/teamviewer_linux.tar.gz";
    sha256 = "1f8934jqj093m1z56yl6k2ah6njkk6pz1rjvpqnryi29pp5piaiy";
  };

  buildInputs = [ makeWrapper ];

  # I need patching, mainly for it not try to use its own 'wine' (in the tarball).
  installPhase = ''
    mkdir -p $out/share/teamviewer $out/bin
    cp -a .tvscript/* $out/share/teamviewer
    cp -a .wine/drive_c $out/share/teamviewer
    sed -i -e 's/^tv_Run//' \
      -e 's/^  setup_tar_env//' \
      -e 's/^  setup_env//' \
      -e 's,^  TV_Wine_dir=.*,  TV_Wine_dir=${wine},' \
      -e 's,progsrc=.*drive_c,progsrc='$out'"/share/teamviewer/drive_c,' \
      $out/share/teamviewer/wrapper

    cat > $out/bin/teamviewer << EOF
    #!${bash}/bin/sh
    # Teamviewer puts symlinks to nix store paths in ~/.teamviewer. When those
    # paths become garbage collected, teamviewer crashes upon start because of
    # those broken symlinks. An easy workaround to this behaviour is simply to
    # delete all symlinks before we start teamviewer. Teamviewer will fixup the
    # symlinks, just like it did the first time the user ran it.
    ${findutils}/bin/find "\$HOME"/.teamviewer/*/*/"Program Files/TeamViewer/" -type l -print0 | ${findutils}/bin/xargs -0 ${coreutils}/bin/rm

    export LD_LIBRARY_PATH=${toldpath}\''${LD_LIBRARY_PATH:+:\$LD_LIBRARY_PATH}
    export PATH=${topath}\''${PATH:+:\$PATH}
    $out/share/teamviewer/wrapper wine "c:\Program Files\TeamViewer\Version7\TeamViewer.exe" "\$@"
    EOF
    chmod +x $out/bin/teamviewer
  '';

  meta = {
    homepage = "http://www.teamviewer.com";
    license = stdenv.lib.licenses.unfree;
    description = "Desktop sharing application, providing remote support and online meetings";
  };
}
