{
  ipset,
  pkg-config,
  rustPlatform,
  reaction,
  ...
}:
reaction.mkReactionPlugin "reaction-plugin-ipset" {
  buildInputs = [ ipset ];
  nativeBuildInputs = [
    rustPlatform.bindgenHook
    pkg-config
  ];
}
