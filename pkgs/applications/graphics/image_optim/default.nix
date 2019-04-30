{ lib, bundlerApp, fetchurl, ruby, makeWrapper,
  withPngcrush ? true,       pngcrush ? null,
  withPngout ? true,         pngout ? null,
  withAdvpng ? true,         advancecomp ? null,
  withOptipng ? true,        optipng ? null,
  withPngquant ? true,       pngquant ? null,
  withJhead ? true,          jhead ? null,
  withJpegoptim ? true,      jpegoptim ? null,
  withJpegrecompress ? true, jpeg-archive ? null,
  withJpegtran ? true,       libjpeg ? null,
  withGifsicle ? true,       gifsicle ? null,
  withSvgo ? true,           svgo ? null
}:

assert withPngcrush       -> pngcrush != null;
assert withPngout         -> pngout != null;
assert withAdvpng         -> advancecomp != null;
assert withOptipng        -> optipng != null;
assert withPngquant       -> pngquant != null;
assert withJhead          -> jhead != null;
assert withJpegoptim      -> jpegoptim != null;
assert withJpegrecompress -> jpeg-archive != null;
assert withJpegtran       -> libjpeg != null;
assert withGifsicle       -> gifsicle != null;
assert withSvgo           -> svgo != null;

with lib;

let
  optionalDepsPath = []
    ++ optional withPngcrush pngcrush
    ++ optional withPngout pngout
    ++ optional withAdvpng advancecomp
    ++ optional withOptipng optipng
    ++ optional withPngquant pngquant
    ++ optional withJhead jhead
    ++ optional withJpegoptim jpegoptim
    ++ optional withJpegrecompress jpeg-archive
    ++ optional withJpegtran libjpeg
    ++ optional withGifsicle gifsicle
    ++ optional withSvgo svgo;
in

bundlerApp {
  pname = "image_optim";
  gemdir = ./.;

  inherit ruby;

  exes = [ "image_optim" ];

  buildInputs = [ makeWrapper ];

  postBuild = ''
    wrapProgram $out/bin/image_optim \
      --prefix PATH : ${makeBinPath optionalDepsPath}
  '';

  meta = with lib; {
    description = "Command line tool and ruby interface to optimize (lossless compress, optionally lossy) jpeg, png, gif and svg images using external utilities (advpng, gifsicle, jhead, jpeg-recompress, jpegoptim, jpegrescan, jpegtran, optipng, pngcrush, pngout, pngquant, svgo)";
    homepage    = https://github.com/toy/image_optim;
    license     = licenses.mit;
    maintainers = with maintainers; [ srghma ];
    platforms   = platforms.all;
  };
}
