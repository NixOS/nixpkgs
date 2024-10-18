{
  buildFHSEnv,
  writeShellScript,
  neovim,
}:
buildFHSEnv {
  name = "nvim-fhs";
  targetPkgs = pkgs: [ neovim ];

  runScript = writeShellScript "nvim-fhs.sh" ''
    exec ${neovim}/bin/nvim "$@"
  '';
}
