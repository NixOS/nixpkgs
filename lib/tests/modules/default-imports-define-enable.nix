{ otherModule ? ./define-enable.nix, ... }:

{
  imports = [ otherModule ];
  importsArgs = [ "otherModule" ];
  config = {};
}
