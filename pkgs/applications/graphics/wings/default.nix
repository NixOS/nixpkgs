{ fetchurl, lib, stdenv, erlang, cl, libGL, libGLU, runtimeShell }:

stdenv.mkDerivation rec {
  pname = "wings";
  version = "2.2.4";

  src = fetchurl {
    url = "mirror://sourceforge/wings/wings-${version}.tar.bz2";
    sha256 = "1xcmifs4vq2810pqqvsjsm8z3lz24ys4c05xkh82nyppip2s89a3";
  };

  ERL_LIBS = "${cl}/lib/erlang/lib";

  patchPhase = ''
    sed -i 's,-Werror ,,' e3d/Makefile
    sed -i 's,../../wings/,../,' icons/Makefile
    find plugins_src -mindepth 2 -type f -name "*.[eh]rl" -exec sed -i 's,wings/src/,../../src/,' {} \;
    find plugins_src -mindepth 2 -type f -name "*.[eh]rl" -exec sed -i 's,wings/e3d/,../../e3d/,' {} \;
    find plugins_src -mindepth 2 -type f -name "*.[eh]rl" -exec sed -i 's,wings/intl_tools/,../../intl_tools/,' {} \;
    find . -type f -name "*.[eh]rl" -exec sed -i 's,wings/src/,../src/,' {} \;
    find . -type f -name "*.[eh]rl" -exec sed -i 's,wings/e3d/,../e3d/,' {} \;
    find . -type f -name "*.[eh]rl" -exec sed -i 's,wings/intl_tools/,../intl_tools/,' {} \;
  '';

  buildInputs = [ erlang cl libGL libGLU ];

  # I did not test the *cl* part. I added the -pa just by imitation.
  installPhase = ''
    mkdir -p $out/bin $out/lib/wings-${version}/ebin
    cp ebin/* $out/lib/wings-${version}/ebin
    cp -R textures shaders plugins $out/lib/wings-${version}
    cat << EOF > $out/bin/wings
    #!${runtimeShell}
    ${erlang}/bin/erl \
      -pa $out/lib/wings-${version}/ebin -run wings_start start_halt "$@"
    EOF
    chmod +x $out/bin/wings
  '';

  meta = {
    homepage = "http://www.wings3d.com/";
    description = "Subdivision modeler inspired by Nendo and Mirai from Izware";
    license = lib.licenses.tcltk;
    maintainers = with lib.maintainers; [ viric ];
    platforms = with lib.platforms; linux;
  };
}
