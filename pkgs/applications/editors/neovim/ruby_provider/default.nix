{ defaultGemConfig, bundlerEnv, makeWrapper, lib, ruby}:
bundlerEnv {
  inherit ruby;
  name = "neovim-ruby-host";
  gemdir = ./.;
  gemConfig = defaultGemConfig // {
    neovim = attrs: {
      postInstall = let
        dir = "${attrs.ruby.gemPath}";
      in ''
        wrapProgram $out/${dir}/bin/neovim-ruby-host \
          --prefix PATH : ${attrs.ruby}/bin \
          --unset GEM_HOME \
          --unset GEM_PATH
      '';
    };
  };
}
