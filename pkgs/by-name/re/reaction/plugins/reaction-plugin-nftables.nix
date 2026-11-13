{
  nftables,
  pkg-config,
  rustPlatform,
  reaction,
  ...
}:
reaction.mkReactionPlugin "reaction-plugin-nftables" {
  buildInputs = [ nftables ];
  nativeBuildInputs = [
    rustPlatform.bindgenHook
    pkg-config
  ];
}
