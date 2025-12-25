let
  pkgs = import ../.. { };
  inherit (pkgs.dockerTools)
    buildImage
    streamLayeredImage
    ;
  inherit (pkgs)
    nix
    hello
    ;

in
{
  imageWithoutSigs = buildImage {
    name = "image-without-sigs";
    tag = "latest";
    copyToRoot = [
      nix
      hello
    ];
    includeNixDB = true;
    includeNixDBHostSignatures = false;
  };

  imageWithSigs = buildImage {
    name = "image-with-sigs";
    tag = "latest";
    copyToRoot = [
      nix
      hello
    ];
    includeNixDB = true;
    includeNixDBHostSignatures = true;
  };

  layeredImageWithoutSigs = streamLayeredImage {
    name = "layered-image-without-sigs";
    tag = "latest";
    contents = [
      nix
      hello
    ];
    includeNixDB = true;
    includeNixDBHostSignatures = false;
  };

  layeredImageWithSigs = streamLayeredImage {
    name = "layered-image-with-sigs";
    tag = "latest";
    contents = [
      nix
      hello
    ];
    includeNixDB = true;
    includeNixDBHostSignatures = true;
  };
}
