{
  SDL2_image,
  SDL2_classic,
  enableSTB ? true,
}:

(SDL2_image.override {
  SDL2 = SDL2_classic;
  inherit enableSTB;
}).overrideAttrs
  {
    pname = "SDL2_classic_image";
  }
