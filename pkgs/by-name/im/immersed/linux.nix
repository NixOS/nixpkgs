{
  pname,
  version,
  src,
  meta,
  appimageTools,
  libgpg-error,
}:

let
  src' = appimageTools.extract {
    inherit pname version;
    src = src;

    # Because of https://github.com/NixOS/nixpkgs/issues/267408
    postExtract = ''
      cp ${libgpg-error}/lib/* $out/usr/lib/
    '';
  };
in

appimageTools.wrapAppImage {
  inherit pname version meta;
  src = src';

  extraPkgs =
    pkgs: with pkgs; [
      libgpg-error
      fontconfig
      libGL
      libgbm
      wayland
      pipewire
      fribidi
      harfbuzz
      freetype
      libthai
      e2fsprogs
      zlib
      libp11
      xorg.libX11
      xorg.libSM
    ];

  multiArch = true;
}
