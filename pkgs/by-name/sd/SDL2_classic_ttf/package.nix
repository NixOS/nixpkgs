{
  SDL2_ttf,
  SDL2_classic,
}:

(SDL2_ttf.override {
  SDL2 = SDL2_classic;
}).overrideAttrs
  {
    pname = "SDL2_classic_ttf";
  }
