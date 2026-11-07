{
  reaction,
  cmake,
  ...
}:
reaction.mkReactionPlugin "reaction-plugin-httpban" {
  nativeBuildInputs = [ cmake ];
}
