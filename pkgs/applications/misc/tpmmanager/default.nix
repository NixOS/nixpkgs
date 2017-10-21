{ stdenv, fetchgit, qt4, qmake4Hook, trousers }:

stdenv.mkDerivation rec {
  version = "0.8.1";
  name = "tpmmanager-${version}";

  src = fetchgit {
    url = "https://github.com/Sirrix-AG/TPMManager";
    rev = "9f989206635a6d2c1342576c90fa73eb239519cd";
    sha256 = "24a606f88fed67ed0d0e61dc220295e9e1ab8db3ef3d028fa34b04ff30652d8e";
  };

  nativeBuildInputs = [ qmake4Hook ];

  buildInputs = [ qt4 trousers ];

  installPhase = ''
    mkdir -p $out/bin
    install -Dpm755 -D bin/tpmmanager $out/bin/tpmmanager

    mkdir -p $out/share/applications
    cat > $out/share/applications/tpmmanager.desktop <<EOF
    [Desktop Entry]
    Type=Application
    Version=1.0
    Name=tpmmanager
    Comment=TPM manager
    Exec=$out/bin/tpmmanager
    Terminal=false
    EOF
    '';

  meta = {
    homepage = https://projects.sirrix.com/trac/tpmmanager;
    description = "Tool for managing the TPM";
    license = stdenv.lib.licenses.gpl2;
    maintainers = with stdenv.lib.maintainers; [ tstrobel ];
    platforms = with stdenv.lib.platforms; linux;
    inherit version;
  };
}
