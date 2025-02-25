{
  buildGoModule,
  anvil-editor,
}:

buildGoModule {
  inherit (anvil-editor) version src meta;

  pname = "anvil-editor-extras";

  modRoot = "anvil-extras";

  vendorHash = "sha256-PH7HSMlCAHn4L1inJDbDcj6n+i6LXakIOqwdUkRjf9E=";
}
