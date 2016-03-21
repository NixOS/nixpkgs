{ luarocks, lib , stdenv,  writeText , readline,  makeWrapper,
  less, ncurses, cmake, openblas, coreutils, fetchgit, libuuid, czmq, openssl,
  gnuplot, fetchurl, lua, src, libjpeg, libpng
} :

let

  common_meta = {
    homepage = http://torch.ch;
    license = stdenv.lib.licenses.bsd3;
    maintainers = with stdenv.lib.maintainers; [ smironov ];
    platforms = stdenv.lib.platforms.gnu;
  };

  distro_src = src;

  default_luarocks = luarocks;

  pkgs_gnuplot = gnuplot;

  luapkgs = rec {

    luarocks = default_luarocks.override {
      inherit lua;
    };

    buildLuaRocks = { rockspec ? "", luadeps ? [] , buildInputs ? []
                    , preBuild ? "" , postInstall ? ""
                    , runtimeDeps ? [] ,  ... }@args :
      let

        luadeps_ =
          luadeps ++
          (lib.concatMap (d : if d ? luadeps then d.luadeps else []) luadeps);

        runtimeDeps_ =
          runtimeDeps ++
          (lib.concatMap (d : if d ? runtimeDeps then d.runtimeDeps else []) luadeps) ++
          [ lua coreutils ];

        mkcfg = ''
          export LUAROCKS_CONFIG=config.lua
          cat >config.lua <<EOF
            rocks_trees = {
                 { name = [[system]], root = [[${luarocks}]] }
               ${lib.concatImapStrings (i : dep :  ", { name = [[dep${toString i}]], root = [[${dep}]] }") luadeps_}
            };

            variables = {
              LUA_BINDIR = "$out/bin";
              LUA_INCDIR = "$out/include";
              LUA_LIBDIR = "$out/lib/lua/${lua.luaversion}";
            };
          EOF
        '';

      in
      stdenv.mkDerivation (args // {

        inherit preBuild postInstall;

        inherit luadeps runtimeDeps;

        phases = [ "unpackPhase" "patchPhase" "buildPhase"];

        buildInputs = runtimeDeps ++ buildInputs ++ [ makeWrapper lua ];

        buildPhase = ''
          eval "$preBuild"
          ${mkcfg}
          eval "`${luarocks}/bin/luarocks --deps-mode=all --tree=$out path`"
          ${luarocks}/bin/luarocks make --deps-mode=all --tree=$out ${rockspec}

          for p in $out/bin/*; do
            wrapProgram $p \
              --suffix LD_LIBRARY_PATH ';' "${lib.makeSearchPath "lib" runtimeDeps_}" \
              --suffix PATH ';' "${lib.makeSearchPath "bin" runtimeDeps_}" \
              --suffix LUA_PATH ';' "\"$LUA_PATH\"" \
              --suffix LUA_PATH ';' "\"$out/share/lua/${lua.luaversion}/?.lua;$out/share/lua/${lua.luaversion}/?/init.lua\"" \
              --suffix LUA_CPATH ';' "\"$LUA_CPATH\"" \
              --suffix LUA_CPATH ';' "\"$out/lib/lua/${lua.luaversion}/?.so;$out/lib/lua/${lua.luaversion}/?/init.so\""
          done

          eval "$postInstall"
        '';
      });

    # FIXME: doesn't installs lua-files for some reason
    # lua-cjson = buildLuaPackage {
    #   name = "lua-cjson";
    #   src = ./extra/lua-cjson;
    #   rockspec = "lua-cjson-2.1devel-1.rockspec";
    # };

    lua-cjson = stdenv.mkDerivation rec {
      name = "lua-cjson";
      src = "${distro_src}/extra/lua-cjson";

      preConfigure = ''
        makeFlags="PREFIX=$out LUA_LIBRARY=$out/lib/lua"
      '';

      buildInputs = [lua];

      installPhase = ''
        make install-extra $makeFlags
      '';
    };

    luafilesystem = buildLuaRocks {
      name = "filesystem";
      src = "${distro_src}/extra/luafilesystem";
      luadeps = [lua-cjson];
      rockspec = "rockspecs/luafilesystem-1.6.3-1.rockspec";
    };

    penlight = buildLuaRocks {
      name = "penlight";
      src = "${distro_src}/extra/penlight";
      luadeps = [luafilesystem];
    };

    luaffifb = buildLuaRocks {
      name = "luaffifb";
      src = "${distro_src}/extra/luaffifb";
    };

    sundown = buildLuaRocks rec {
      name = "sundown";
      src = "${distro_src}/pkg/sundown";
      rockspec = "rocks/${name}-scm-1.rockspec";
    };

    cwrap = buildLuaRocks rec {
      name = "cwrap";
      src = "${distro_src}/pkg/cwrap";
      rockspec = "rocks/${name}-scm-1.rockspec";
    };

    paths = buildLuaRocks rec {
      name = "paths";
      src = "${distro_src}/pkg/paths";
      buildInputs = [cmake];
      rockspec = "rocks/${name}-scm-1.rockspec";
    };

    torch = buildLuaRocks rec {
      name = "torch";
      src = "${distro_src}/pkg/torch";
      luadeps = [ paths cwrap ];
      buildInputs = [ cmake ];
      rockspec = "rocks/torch-scm-1.rockspec";
      preBuild = ''
        substituteInPlace ${rockspec} \
          --replace '"sys >= 1.0"' ' '
        export LUA_PATH="$src/?.lua;$LUA_PATH"
      '';
      meta = common_meta // {
        description = "Torch is a machine-learning library";
        longDescription = ''
          Torch is the main package in [Torch7](http://torch.ch) where data
          structures for multi-dimensional tensors and mathematical operations
          over these are defined. Additionally, it provides many utilities for
          accessing files, serializing objects of arbitrary types and other
          useful utilities.
        '';
      };
    };

    dok = buildLuaRocks rec {
      name = "dok";
      src = "${distro_src}/pkg/dok";
      luadeps = [sundown];
      rockspec = "rocks/${name}-scm-1.rockspec";
    };

    sys = buildLuaRocks rec {
      name = "sys";
      luadeps = [torch];
      buildInputs = [readline cmake];
      src = "${distro_src}/pkg/sys";
      rockspec = "sys-1.1-0.rockspec";
      preBuild = ''
        export Torch_DIR=${torch}/share/cmake/torch
      '';
    };

    xlua = buildLuaRocks rec {
      name = "xlua";
      luadeps = [torch sys];
      src = "${distro_src}/pkg/xlua";
      rockspec = "xlua-1.0-0.rockspec";
    };

    nn = buildLuaRocks rec {
      name = "nn";
      luadeps = [torch luaffifb];
      buildInputs = [cmake];
      src = "${distro_src}/extra/nn";
      rockspec = "rocks/nn-scm-1.rockspec";
      preBuild = ''
        export Torch_DIR=${torch}/share/cmake/torch
      '';
    };

    graph = buildLuaRocks rec {
      name = "graph";
      luadeps = [ torch ];
      buildInputs = [cmake];
      src = "${distro_src}/extra/graph";
      rockspec = "rocks/graph-scm-1.rockspec";
      preBuild = ''
        export Torch_DIR=${torch}/share/cmake/torch
      '';
    };

    nngraph = buildLuaRocks rec {
      name = "nngraph";
      luadeps = [ torch nn graph ];
      buildInputs = [cmake];
      src = "${distro_src}/extra/nngraph";
      preBuild = ''
        export Torch_DIR=${torch}/share/cmake/torch
      '';
    };

    image = buildLuaRocks rec {
      name = "image";
      luadeps = [ torch dok sys xlua ];
      buildInputs = [cmake libjpeg libpng];
      src = "${distro_src}/pkg/image";
      rockspec = "image-1.1.alpha-0.rockspec";
      preBuild = ''
        export Torch_DIR=${torch}/share/cmake/torch
      '';
    };

    optim = buildLuaRocks rec {
      name = "optim";
      luadeps = [ torch ];
      buildInputs = [cmake];
      src = "${distro_src}/pkg/optim";
      rockspec = "optim-1.0.5-0.rockspec";
      preBuild = ''
        export Torch_DIR=${torch}/share/cmake/torch
      '';
    };

    gnuplot = buildLuaRocks rec {
      name = "gnuplot";
      luadeps = [ torch paths ];
      runtimeDeps = [ pkgs_gnuplot less ];
      src = "${distro_src}/pkg/gnuplot";
      rockspec = "rocks/gnuplot-scm-1.rockspec";
    };

    trepl = buildLuaRocks rec {
      name = "trepl";
      luadeps = [torch gnuplot paths penlight graph nn nngraph image gnuplot optim sys dok];
      runtimeDeps = [ ncurses readline ];
      src = "${distro_src}/exe/trepl";
      meta = common_meta // {
        description = "A pure Lua REPL for Lua(JIT), with heavy support for Torch types.";
      };
    };

    lbase64 = buildLuaRocks rec {
      name = "lbase64";
      src = fetchgit {
        url = "https://github.com/LuaDist2/lbase64";
        rev = "1e9e4f1e0bf589a0ed39f58acc185ec5e213d207";
        sha256 = "1i1fpy9v6r4w3lrmz7bmf5ppq65925rv90gx39b3pykfmn0hcb9c";
      };
    };

    luuid = stdenv.mkDerivation rec {
      name = "luuid";
      src = fetchgit {
        url = "https://github.com/LuaDist/luuid";
        sha256 = "062gdf1rild11jg46vry93hcbb36b4527pf1dy7q9fv89f7m2nav";
      };

      preConfigure = ''
        cmakeFlags="-DLUA_LIBRARY=${lua}/lib/lua/${lua.luaversion} -DINSTALL_CMOD=$out/lib/lua/${lua.luaversion} -DINSTALL_MOD=$out/lib/lua/${lua.luaversion}"
      '';

      buildInputs = [cmake libuuid lua];
      meta = {
        # FIXME: set the exact revision for src
        broken = true;
      };
    };

    # Doesn't work due to missing deps (according to luarocs).
    itorch = buildLuaRocks rec {
      name = "itorch";
      luadeps = [torch gnuplot paths penlight graph nn nngraph image gnuplot
                  optim sys dok lbase64 lua-cjson luuid];
      buildInputs = [czmq openssl];
      src = "${distro_src}/extra/iTorch";
      meta = {
        # FIXME: figure out whats wrong with deps
        broken = true;
      };
    };


  };

in

luapkgs


