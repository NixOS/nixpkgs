{ vimUtils, vim_configurable, writeText, neovim, vimPlugins
, lib, fetchFromGitHub, neovimUtils, wrapNeovimUnstable
, neovim-unwrapped
, fetchFromGitLab
, pkgs
}:
let
  inherit (vimUtils) buildVimPluginFrom2Nix;
  inherit (neovimUtils) makeNeovimConfig;

  packages.myVimPackage.start = with vimPlugins; [ vim-nix ];

  plugins = with vimPlugins; [
    {
      plugin = vim-obsession;
      config = ''
        map <Leader>$ <Cmd>Obsession<CR>
      '';
    }
  ];

  nvimConfNix = makeNeovimConfig {
    inherit plugins;
    customRC = ''
      " just a comment
    '';
  };

  nvimAutoDisableWrap = makeNeovimConfig { };

  nvimConfDontWrap = makeNeovimConfig {
    inherit plugins;
    customRC = ''
      " just a comment
    '';
  };

  wrapNeovim2 = suffix: config:
    wrapNeovimUnstable neovim-unwrapped (config // {
      extraName = suffix;
    });

  nmt = fetchFromGitLab {
    owner = "rycee";
    repo = "nmt";
    rev = "d2cc8c1042b1c2511f68f40e2790a8c0e29eeb42";
    sha256 = "1ykcvyx82nhdq167kbnpgwkgjib8ii7c92y3427v986n2s5lsskc";
  };

  runTest = neovim-drv: buildCommand:
    pkgs.runCommandLocal "test-${neovim-drv.name}" ({
      nativeBuildInputs = [ ];
      meta.platforms = neovim-drv.meta.platforms;
    }) (''
      source ${nmt}/bash-lib/assertions.sh
      vimrc="${writeText "init.vim" neovim-drv.initRc}"
      vimrcGeneric="$out/patched.vim"
      mkdir $out
      ${pkgs.perl}/bin/perl -pe "s|\Q$NIX_STORE\E/[a-z0-9]{32}-|$NIX_STORE/eeeeeeeeeeeeeeeeeeeeeeeeeeeeeeee-|g" < "$vimrc" > "$vimrcGeneric"
    '' + buildCommand);

in
  pkgs.recurseIntoAttrs (
rec {
  vim_empty_config = vimUtils.vimrcFile { beforePlugins = ""; customRC = ""; };

  ### neovim tests
  ##################
  nvim_with_plugins = wrapNeovim2 "-with-plugins" nvimConfNix;

  nvim_via_override = neovim.override {
    extraName = "-via-override";
    configure = {
      packages.foo.start = [ vimPlugins.ale ];
      customRC = ''
        :help ale
      '';
    };
  };

  nvim_with_aliases = neovim.override {
    extraName = "-with-aliases";
    vimAlias = true;
    viAlias = true;
  };

  nvim_with_plug = neovim.override {
    extraName = "-with-plug";
    configure.plug.plugins = with pkgs.vimPlugins; [
      (base16-vim.overrideAttrs(old: { pname = old.pname + "-unique-for-tests-please-dont-use"; }))
    ];
    configure.customRC = ''
      color base16-tomorrow-night
      set background=dark
    '';
  };

  run_nvim_with_plug = runTest nvim_with_plug ''
    export HOME=$TMPDIR
    ${nvim_with_plug}/bin/nvim -i NONE -c 'color base16-tomorrow-night'  +quit! -e
  '';


  # check that the vim-doc hook correctly generates the tag
  # we know for a fact packer has a doc folder
  checkForTags = vimPlugins.packer-nvim.overrideAttrs(oldAttrs: {
    doInstallCheck = true;
    installCheckPhase = ''
      [ -f $out/doc/tags ]
    '';
  });


  # nixpkgs should detect that no wrapping is necessary
  nvimShouldntWrap = wrapNeovim2 "-should-not-wrap" nvimAutoDisableWrap;

  # this will generate a neovimRc content but we disable wrapping
  nvimDontWrap = wrapNeovim2 "-forced-nowrap" (makeNeovimConfig {
    wrapRc = false;
    customRC = ''
      " this shouldn't trigger the creation of an init.vim
    '';
  });

  force-nowrap = runTest nvimDontWrap ''
      ! grep "-u" ${nvimDontWrap}/bin/nvim
  '';

  nvim_via_override-test = runTest nvim_via_override ''
      assertFileContent \
        "$vimrcGeneric" \
        "${./neovim-override.vim}"
  '';


  checkAliases = runTest nvim_with_aliases ''
      folder=${nvim_with_aliases}/bin
      assertFileExists "$folder/vi"
      assertFileExists "$folder/vim"
  '';

  # having no RC generated should autodisable init.vim wrapping
  nvim_autowrap = runTest nvim_via_override ''
      ! grep "-u" ${nvimShouldntWrap}/bin/nvim
  '';


  # system remote plugin manifest should be generated, deoplete should be usable
  # without the user having to do `UpdateRemotePlugins`. To test, launch neovim
  # and do `:call deoplete#enable()`. It will print an error if the remote
  # plugin is not registered.
  test_nvim_with_remote_plugin = neovim.override {
    extraName = "-remote";
    configure.packages.foo.start = with vimPlugins; [ deoplete-nvim ];
  };

  # only neovim makes use of `requiredPlugins`, test this here
  test_nvim_with_vim_nix_using_pathogen = neovim.override {
    extraName = "-pathogen";
    configure.pathogen.pluginNames = [ "vim-nix" ];
  };

  nvimWithLuaPackages = wrapNeovim2 "-with-lua-packages" (makeNeovimConfig {
    extraLuaPackages = ps: [ps.mpack];
    customRC = ''
      lua require("mpack")
    '';
  });

  nvim_with_lua_packages = runTest nvimWithLuaPackages ''
    export HOME=$TMPDIR
    ${nvimWithLuaPackages}/bin/nvim -i NONE --noplugin -es
  '';
})
