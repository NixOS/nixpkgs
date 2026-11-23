{
  reaction,
  cmake,
  pkg-config,
  zstd,
  ...
}:
reaction.mkReactionPlugin "reaction-plugin-httpban" {
  nativeBuildInputs = [
    cmake
    pkg-config
  ];
  buildInputs = [
    zstd
  ];
}
