{ stdenv, fetchFromGitHub, jdk, jre, gradle, git, makeWrapper }:

stdenv.mkDerivation rec {
  name = "freeplane-1.6.13";

  src = fetchFromGitHub {
    owner = "freeplane";
    repo = "freeplane";
    rev = "d0767ea431177cbd58929901afb1e9938e4756bf";
    sha256 = "0lcr968xvj1zl5v33ih243lyd82gfh7hplj3drdsdi5rh6d2a57y";
  };

  buildInputs = [ jdk gradle git makeWrapper ];

  buildPhase = ''
    export GRADLE_USER_HOME="/tmp"
    gradle dist
  '';

  installPhase = ''
    mkdir -p $out/{bin,nix-support}
    cp -r BIN $out/nix-support
    sed -i 's/which/type -p/' $out/nix-support/BIN/freeplane.sh

    makeWrapper $out/nix-support/BIN/freeplane.sh $out/bin/freeplane --set JAVA_HOME ${jre}
    chmod +x $out/nix-support/BIN/freeplane.sh

    mkdir $out/share
    mkdir $out/share/applications
    mkdir $out/share/icons
    cp freeplane/resources/linux/freeplane.desktop $out/share/applications
    cp freeplane/resources/images/Freeplane_app_menu_128.png $out/share/icons/freeplane.png
  '';

  meta = with stdenv.lib; {
    description = "Mind-mapping software";
    homepage = https://www.freeplane.org/wiki/index.php/Home;
    license = licenses.gpl2Plus;
    platforms = platforms.linux;
  };
}
