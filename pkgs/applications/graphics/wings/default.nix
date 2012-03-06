{ fetchurl, stdenv, erlang, esdl }:

stdenv.mkDerivation rec {
  name = "wings-1.4.1";
  src = fetchurl {
    url = "mirror://sourceforge/wings/${name}.tar.bz2";
    sha256 = "16kqy92rapmbvkc58mc50cidp1pm8nlwlwx69riyadc9w4qs9bji";
  };

  ERL_LIBS = "${esdl}/lib/erlang/addons";

  patchPhase = ''
    sed -i 's,include("sdl_keyboard.hrl"),include_lib("esdl/include/sdl_keyboard.hrl"),' \
      src/wings_body.erl plugins_src/commands/wpc_constraints.erl
  '';

  buildInputs = [ erlang esdl ];

  installPhase = ''
    mkdir -p $out/bin $out/lib/${name}/ebin
    cp ebin/* $out/lib/${name}/ebin
    cp -R fonts textures shaders plugins $out/lib/$name
    cat << EOF > $out/bin/wings
    #!/bin/sh
    export ROOTDIR=$out/lib/erlang/addons/${name}
    ${erlang}/bin/erl -smp disable -pa ${esdl}/lib/erlang/addons/${esdl.name}/ebin \
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

