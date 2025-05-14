{
  SDL2_classic,
  enableSTB ? null,
}:
if enableSTB == null then SDL2_classic.sdlLibs.SDL2_image else SDL2_classic.sdlLibs.SDL2_image.override { inherit enableSTB; }
