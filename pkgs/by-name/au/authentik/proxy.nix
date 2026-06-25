{
  buildGoModule,
  mkGoOutpost,
}:
mkGoOutpost buildGoModule (finalAttrs: {
  outpostName = "proxy";

  meta.description = "Authentik proxy outpost which is used for HTTP reverse proxy authentication";
})
