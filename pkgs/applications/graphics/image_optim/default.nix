{ lib, bundlerApp, bundlerUpdateScript, makeWrapper,
  withPngcrush ? true,       pngcrush,
  withPngout ? true,         pngout,
  withAdvpng ? true,         advancecomp,
  withOptipng ? true,        optipng,
  withPngquant ? true,       pngquant,
  withJhead ? true,          jhead,
  withJpegoptim ? true,      jpegoptim,
  withJpegrecompress ? true, jpeg-archive,
  withJpegtran ? true,       libjpeg,
  withGifsicle ? true,       gifsicle,
  withSvgo ? true,           svgo
}:

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

  exes = [ "image_optim" ];

  buildInputs = [ makeWrapper ];

  postBuild = ''
    wrapProgram $out/bin/image_optim \
      --prefix PATH : ${lib.escapeShellArg (makeBinPath optionalDepsPath)}
  '';

  passthru.updateScript = bundlerUpdateScript "image_optim";

  meta = with lib; {
    description = "Command line tool and ruby interface to optimize (lossless compress, optionally lossy) jpeg, png, gif and svg images using external utilities (advpng, gifsicle, jhead, jpeg-recompress, jpegoptim, jpegrescan, jpegtran, optipng, pngcrush, pngout, pngquant, svgo)";
    homepage    = "https://github.com/toy/image_optim";
    license     = licenses.mit;
    maintainers = with maintainers; [ srghma nicknovitski ];
    platforms   = platforms.all;
  };
}
