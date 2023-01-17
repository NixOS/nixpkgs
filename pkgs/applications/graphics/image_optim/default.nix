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

let
  optionalDepsPath = []
    ++ lib.optional withPngcrush pngcrush
    ++ lib.optional withPngout pngout
    ++ lib.optional withAdvpng advancecomp
    ++ lib.optional withOptipng optipng
    ++ lib.optional withPngquant pngquant
    ++ lib.optional withJhead jhead
    ++ lib.optional withJpegoptim jpegoptim
    ++ lib.optional withJpegrecompress jpeg-archive
    ++ lib.optional withJpegtran libjpeg
    ++ lib.optional withGifsicle gifsicle
    ++ lib.optional withSvgo svgo;
in

bundlerApp {
  pname = "image_optim";
  gemdir = ./.;

  exes = [ "image_optim" ];

  nativeBuildInputs = [ makeWrapper ];

  postBuild = ''
    wrapProgram $out/bin/image_optim \
      --prefix PATH : ${lib.escapeShellArg (lib.makeBinPath optionalDepsPath)}
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
