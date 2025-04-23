{
  SDL2_mixer,
  SDL2_classic,
}:

(SDL2_mixer.override {
  SDL2 = SDL2_classic;
}).overrideAttrs
  {
    pname = "SDL2_classic_mixer";
  }
