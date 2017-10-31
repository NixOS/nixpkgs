{ fetchurl, stdenv, erlang, esdl, cl }:

stdenv.mkDerivation rec {
  name = "wings-1.5.4";
  src = fetchurl {
    url = "mirror://sourceforge/wings/${name}.tar.bz2";
    sha256 = "0qz6rmmkqgk3p0d3v2ikkf22n511bq0m7xp3kkradwrp28fcl15x";
  };

  ERL_LIBS = "${esdl}/lib/erlang/lib:${cl}/lib/erlang/lib";

  patchPhase = ''
    sed -i 's,include("sdl_keyboard.hrl"),include_lib("esdl/include/sdl_keyboard.hrl"),' \
      src/wings_body.erl plugins_src/commands/wpc_constraints.erl

    # Fix reference
    sed -i 's,wings/e3d/,,' plugins_src/import_export/wpc_lwo.erl
  '';

  buildInputs = [ erlang esdl cl ];

  # I did not test the *cl* part. I added the -pa just by imitation.
  installPhase = ''
    mkdir -p $out/bin $out/lib/${name}/ebin
    cp ebin/* $out/lib/${name}/ebin
    cp -R fonts textures shaders plugins $out/lib/$name
    cat << EOF > $out/bin/wings
    #!/bin/sh
    ${erlang}/bin/erl -smp disable \
      -pa ${esdl}/lib/erlang/lib/${cl.name}/ebin \
      -pa ${esdl}/lib/erlang/lib/${esdl.name}/ebin \
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

