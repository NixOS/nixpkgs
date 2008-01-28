args:
args.stdenv.mkDerivation {
  name = "blender-2.45";

  src = args.fetchurl {
    url = http://download.blender.org/source/blender-2.45.tar.gz;
    sha256 = "1bi7j1fcvrpb96sjpcbm4sldf359sgskfhv7a8pgcxj0bnhp47wj";
  };

  phases="unpackPhase buildPhase";

  inherit (args) scons SDL freetype openal python openexr mesa;

  buildInputs =(with args; [python scons
         gettext libjpeg libpng zlib freetype /* fmod smpeg */ freealut openal x11 mesa inputproto libtiff libXi ]);

  # patch SConstruct so that we can pass on additional include.  Either blender
  # or openEXR is broken. I think OpenEXR should use include "" isntead of <> to
  # include files beeing in the same directory
  buildPhase = "
    sed -i -e \"s=##### END SETUP ##########=env['CPPFLAGS'].append(os.getenv('CPPFLAGS').split(':'))\\n##### END SETUP ##########=\" SConstruct\n"
    + " CPPFLAGS=-I$openexr/include/OpenEXR"
    + " scons PREFIX=\$out/nix-support"
    + " BF_SDL=\$SDL"
    + " BF_SDL_LIBPATH=\$SDL/lib"
    + " BF_FREETYPE=\$freetype"
    + " BF_OPENAL=\$openal"
    + " BF_PYTHON=\$python"
    + " BF_OPENEXR_INC=\$openexr/include"
    + " BF_OPENEXR_LIBPATH=\$openexr/lib"
    + " BF_INSTALLDIR=\$out/nix-support/dontLinkThatMuch \n"
    + " ensureDir \$out/bin\n"
    + " ln -s \$out/nix-support/dontLinkThatMuch/blender \$out/bin/blender"
    ;

  meta = { 
      description = "3D Creation/Animation/Publishing System";
      homepage = http://www.blender.org;
      license = "GPL-2 BL";
    };
}
