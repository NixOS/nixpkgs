# Enables composition with nix-shell
addGRCBlocksPath() {
  addToSearchPath GRC_BLOCKS_PATH $1/share/gnuradio/grc/blocks
}
addEnvHooks "$targetOffset" addGRCBlocksPath
