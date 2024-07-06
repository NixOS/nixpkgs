{ lib, stdenv, fetchzip, fetchFromGitHub, fetchpatch, fetchurl, xmlstarlet, makeWrapper, ant, jdk, rsync, javaPackages, libXxf86vm, gsettings-desktop-schemas, processing, unzip }:

# TODO: still creates
# brainflow_svm.model
# libBoardController.so
# libDataHandler.so
# libGanglionLib.so
# libMLModule.so
# libunicorn.so

# Could use this, but don't know correct version
#
# let
#   brainflowLibs = fetchzip {
#     url = "https://github.com/brainflow-dev/brainflow/releases/download/3.0.1/compiled_libs.tar";
#     sha256 = "1wggjq5bvrxbcgrcwlkfbbw1358kdbyyywrqrsixq9gskrp946iy";
#     stripRoot = false;
#   };
# in

stdenv.mkDerivation rec {
  pname = "openbcigui";
  version = "v5.0.9";

  src = fetchFromGitHub {
    owner = "OpenBCI";
    repo = "OpenBCI_GUI";
    rev = version;
    sha256 = "0lg194ssj4g7lfczkja6q314z2w2168anm9wv81szxsmaqzz973d";
  };

  patches = [ ./readonly.patch ];

  nativeBuildInputs = [ makeWrapper unzip ];
  buildInputs = [ jdk ];

  # Q: why we copy libs to `$TMP/sketchbook`?
  # A: b.c. processing-java thinks $TMP is a $HOME
  #
  # b.c. of https://github.com/processing/processing/blob/a6e0e227a948e7e2dc042c04504d6f5b8cf0c1a6/app/src/processing/app/platform/LinuxPlatform.java#L82
  # "sketchbook folder" should be not a $HOME/sketchbook (/homeless-shelter/sketchbook), but a $TMP/sketchbook (/build/sketchbook)
  #
  # to test run this in installPhase
  #
  # ```
  # cat << EOF > ./Test.java
  # public class Test {
  #     public static void main(String [] args) {
  #         System.out.println(System.getProperty("user.home"));
  #         System.exit(0);
  #     }
  # }
  # EOF
  # ${processing}/processing/java/bin/javac Test.java
  # ${processing}/processing/java/bin/java Test
  # ```

  # Q: why we unpack jar?
  # A: b.c. that's what lib does https://github.com/OpenBCI/brainflow/blob/98ddcc91d07344b86cea010fb86b47329ebc7323/java-package/brainflow/src/main/java/brainflow/BoardShim.java#L118
  # but then https://github.com/NixOS/nixpkgs/pull/158788#issuecomment-1038453957
  # so we help to find the libs

  installPhase = ''
    mkdir $TMP/sketchbook

    # TODO: https://github.com/processing/processing-docs/issues/790#issuecomment-1038232853
    cp -r OpenBCI_GUI/libraries/ $TMP/sketchbook

    ${processing}/bin/processing-java --sketch=OpenBCI_GUI --output=$out --no-java --export

    ln -s ${jdk} $out/java

    unzip $src/OpenBCI_GUI/libraries/brainflow/library/brainflow.jar -d $out/brainflowLibs "brainflow/*.so"

    makeWrapper $out/OpenBCI_GUI $out/bin/openbcigui \
        --prefix XDG_DATA_DIRS : ${gsettings-desktop-schemas}/share/gsettings-schemas/${gsettings-desktop-schemas.name} \
        --prefix _JAVA_OPTIONS " " -Dawt.useSystemAAFontSettings=lcd \
        --prefix LD_LIBRARY_PATH : ${libXxf86vm}/lib \
        --prefix LD_LIBRARY_PATH : $out/brainflowLibs/brainflow
  '';

  meta = with lib; {
    description = "A cross platform application for the OpenBCI Cyton and Ganglion.";
    homepage = "https://github.com/OpenBCI/OpenBCI_GUI";
    license = licenses.mit;
    platforms = platforms.linux;
  };
}
