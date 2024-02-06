{ callPackage }:

(callPackage ./generic.nix { }) {
  channel = "edge";
  version = "24.2.1";
  sha256 = "1flbjsa2wj35zgiq4vgb2bqvjvxmpla6fnrlkwnh2l10w4i2n5sl";
  vendorHash = "sha256-1DyqtUSMzVahy8yzX8HAnCe3UI5Z1Pht5XQaMS2i9mw=";
}
