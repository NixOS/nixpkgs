{
  buildGoModule,
  mkGoOutpost,
}:
mkGoOutpost buildGoModule (finalAttrs: {
  outpostName = "radius";

  meta.description = "Authentik radius outpost which is used for the external radius API";
})
