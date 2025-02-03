{
  extendMkDerivation' =
    mkDerivationBase: attrsOverlay: fpargs:
    (mkDerivationBase fpargs).overrideAttrs attrsOverlay;
}
