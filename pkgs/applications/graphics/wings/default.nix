{ fetchurl, stdenv, erlang, cl, libGL, libGLU, runtimeShell }:

stdenv.mkDerivation rec {
  name = "wings-2.2.1";
  src = fetchurl {
    url = "mirror://sourceforge/wings/${name}.tar.bz2";
    sha256 = "1adlq3wd9bz0hjznpzsgilxgsbhr0kk01f06872mq37v4cbw76bh";
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
    mkdir -p $out/bin $out/lib/${name}/ebin
    cp ebin/* $out/lib/${name}/ebin
    cp -R textures shaders plugins $out/lib/$name
    cat << EOF > $out/bin/wings
    #!${runtimeShell}
    ${erlang}/bin/erl \
      -pa $out/lib/${name}/ebin -run wings_start start_halt "$@"
    EOF
    chmod +x $out/bin/wings
  '';

  meta = {
    homepage = http://www.wings3d.com/;
    description = "Subdivision modeler inspired by Nendo and Mirai from Izware";
    license = "BSD";
    maintainers = with stdenv.lib.maintainers; [viric];
    platforms = with stdenv.lib.platforms; linux;
  };
}
