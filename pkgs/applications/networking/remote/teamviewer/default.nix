{ stdenv, fetchurl, libX11, libXtst, libXext, libXdamage, libXfixes, wine, makeWrapper
, bash }:

assert stdenv.system == "i686-linux";
let
  topath = "${wine}/bin";

  toldpath = stdenv.lib.concatStringsSep ":" (map (x: "${x}/lib") 
    [ stdenv.gcc.gcc libX11 libXtst libXext libXdamage libXfixes wine ]);
in
stdenv.mkDerivation {
  name = "teamviewer-7.0.9377";
  src = fetchurl {
    url = "http://www.teamviewer.com/download/version_7x/teamviewer_linux.tar.gz";
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
    export LD_LIBRARY_PATH=${toldpath}\''${LD_LIBRARY_PATH:+:\$LD_LIBRARY_PATH}
    export PATH=${topath}\''${PATH:+:\$PATH}
    $out/share/teamviewer/wrapper wine "c:\Program Files\TeamViewer\Version7\TeamViewer.exe" "\$@"
    EOF
    chmod +x $out/bin/teamviewer
  '';

  meta = {
    homepage = "http://www.teamviewer.com";
    license = "unfree";
    description = "Desktop sharing application, providing remote support and online meetings";
  };
}
