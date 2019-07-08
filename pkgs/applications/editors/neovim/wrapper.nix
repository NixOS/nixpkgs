{ stdenv, lib, makeWrapper
, vimUtils
, bundlerEnv, ruby
, nodejs
, nodePackages
, pythonPackages
, python3Packages
}:
with stdenv.lib;

neovim:

let
  wrapper = {
      extraMakeWrapperArgs ? ""
    , withPython ? true,  extraPythonPackages ? (_: []) /* the function you would have passed to python.withPackages */
    , withPython3 ? true,  extraPython3Packages ? (_: []) /* the function you would have passed to python.withPackages */
    , withNodeJs? false
    , withRuby ? true
    , vimAlias ? false
    , viAlias ? false
    , configure ? {}
  }:
  let

  rubyEnv = bundlerEnv {
    name = "neovim-ruby-env";
    gemdir = ./ruby_provider;
    postBuild = ''
      ln -sf ${ruby}/bin/* $out/bin
    '';
  };

  /* for compatibility with passing extraPythonPackages as a list; added 2018-07-11 */
  compatFun = funOrList: (if builtins.isList funOrList then
    (_: lib.warn "passing a list as extraPythonPackages to the neovim wrapper is deprecated, pass a function as to python.withPackages instead" funOrList)
    else funOrList);
  extraPythonPackagesFun = compatFun extraPythonPackages;
  extraPython3PackagesFun = compatFun extraPython3Packages;

  requiredPlugins = vimUtils.requiredPlugins configure;
  getDeps = attrname: map (plugin: plugin.${attrname} or (_:[]));

  pluginPythonPackages = getDeps "pythonDependencies" requiredPlugins;
  pythonEnv = pythonPackages.python.withPackages(ps:
        [ ps.pynvim ]
        ++ (extraPythonPackagesFun ps)
        ++ (concatMap (f: f ps) pluginPythonPackages));

  pluginPython3Packages = getDeps "python3Dependencies" requiredPlugins;
  python3Env = python3Packages.python.withPackages (ps:
        [ ps.pynvim ]
        ++ (extraPython3PackagesFun ps)
        ++ (concatMap (f: f ps) pluginPython3Packages));

  binPath = makeBinPath (optionals withRuby [rubyEnv] ++ optionals withNodeJs [nodejs]);

  in
  stdenv.mkDerivation {
      name = "neovim-${stdenv.lib.getVersion neovim}";
      buildCommand = let bin="${neovim}/bin/nvim"; in ''
        if [ ! -x "${bin}" ]
        then
            echo "cannot find executable file \`${bin}'"
            exit 1
        fi

        makeWrapper "$(readlink -v --canonicalize-existing "${bin}")" \
          "$out/bin/nvim" --add-flags " \
        --cmd \"${if withNodeJs then "let g:node_host_prog='${nodePackages.neovim}/bin/neovim-node-host'" else "let g:loaded_node_provider=1"}\" \
        --cmd \"${if withPython then "let g:python_host_prog='$out/bin/nvim-python'" else "let g:loaded_python_provider = 1"}\" \
        --cmd \"${if withPython3 then "let g:python3_host_prog='$out/bin/nvim-python3'" else "let g:loaded_python3_provider = 1"}\" \
        --cmd \"${if withRuby then "let g:ruby_host_prog='$out/bin/nvim-ruby'" else "let g:loaded_ruby_provider=1"}\" " \
        --suffix PATH : ${binPath} \
        ${optionalString withRuby '' --set GEM_HOME ${rubyEnv}/${rubyEnv.ruby.gemPath}'' }
      ''
      + optionalString (!stdenv.isDarwin) ''
        # copy and patch the original neovim.desktop file
        mkdir -p $out/share/applications
        substitute ${neovim}/share/applications/nvim.desktop $out/share/applications/nvim.desktop \
          --replace 'TryExec=nvim' "TryExec=$out/bin/nvim" \
          --replace 'Name=Neovim' 'Name=WrappedNeovim'
      ''
      + optionalString withPython ''
        makeWrapper ${pythonEnv}/bin/python $out/bin/nvim-python --unset PYTHONPATH
      '' + optionalString withPython3 ''
        makeWrapper ${python3Env}/bin/python3 $out/bin/nvim-python3 --unset PYTHONPATH
      '' + optionalString withRuby ''
        ln -s ${rubyEnv}/bin/neovim-ruby-host $out/bin/nvim-ruby
      '' + optionalString vimAlias ''
        ln -s $out/bin/nvim $out/bin/vim
      '' + optionalString viAlias ''
        ln -s $out/bin/nvim $out/bin/vi
      '' + optionalString (configure != {}) ''
        echo "Generating remote plugin manifest"
        export NVIM_RPLUGIN_MANIFEST=$out/rplugin.vim
        # Launch neovim with a vimrc file containing only the generated plugin
        # code. Pass various flags to disable temp file generation
        # (swap/viminfo) and redirect errors to stderr.
        # Only display the log on error since it will contain a few normally
        # irrelevant messages.
        if ! $out/bin/nvim \
          -u ${vimUtils.vimrcFile (configure // { customRC = ""; })} \
          -i NONE -n \
          -E -V1rplugins.log -s \
          +UpdateRemotePlugins +quit! > outfile 2>&1; then
          cat outfile
          echo -e "\nGenerating rplugin.vim failed!"
          exit 1
        fi
        unset NVIM_RPLUGIN_MANIFEST

        # this relies on a patched neovim, see
        # https://github.com/neovim/neovim/issues/9413
        wrapProgram $out/bin/nvim \
          --set NVIM_SYSTEM_RPLUGIN_MANIFEST $out/rplugin.vim \
          --add-flags "-u ${vimUtils.vimrcFile configure}" ${extraMakeWrapperArgs}
      '';

    preferLocalBuild = true;

    buildInputs = [makeWrapper];
    passthru = { unwrapped = neovim; };

    meta = neovim.meta // {
      description = neovim.meta.description;
      hydraPlatforms = [];
      # prefer wrapper over the package
      priority = (neovim.meta.priority or 0) - 1;
    };
  };
in
  lib.makeOverridable wrapper
