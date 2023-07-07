{ lib, bundlerApp, bundlerUpdateScript, makeWrapper,
  withPngcrush ? true,       pngcrush,
  withPngout ? false,        pngout, # disabled by default because it's unfree
  withAdvpng ? true,         advancecomp,
  withOptipng ? true,        optipng,
  withPngquant ? true,       pngquant,
  withOxipng ? true,         oxipng,
  withJhead ? true,          jhead,
  withJpegoptim ? true,      jpegoptim,
  withJpegrecompress ? true, jpeg-archive,
  withJpegtran ? true,       libjpeg,
  withGifsicle ? true,       gifsicle,
  withSvgo ? true,           svgo
}:

with lib;

let
  optionalDepsPath = optional withPngcrush pngcrush
    ++ optional withPngout pngout
    ++ optional withAdvpng advancecomp
    ++ optional withOptipng optipng
    ++ optional withPngquant pngquant
    ++ optional withOxipng oxipng
    ++ optional withJhead jhead
    ++ optional withJpegoptim jpegoptim
    ++ optional withJpegrecompress jpeg-archive
    ++ optional withJpegtran libjpeg
    ++ optional withGifsicle gifsicle
    ++ optional withSvgo svgo;

  disabledWorkersFlags = optional (!withPngcrush) "--no-pngcrush"
    ++ optional (!withPngout) "--no-pngout"
    ++ optional (!withAdvpng) "--no-advpng"
    ++ optional (!withOptipng) "--no-optipng"
    ++ optional (!withPngquant) "--no-pngquant"
    ++ optional (!withOxipng) "--no-oxipng"
    ++ optional (!withJhead) "--no-jhead"
    ++ optional (!withJpegoptim) "--no-jpegoptim"
    ++ optional (!withJpegrecompress) "--no-jpegrecompress"
    ++ optional (!withJpegtran) "--no-jpegtran"
    ++ optional (!withGifsicle) "--no-gifsicle"
    ++ optional (!withSvgo) "--no-svgo";
in

bundlerApp {
  pname = "image_optim";
  gemdir = ./.;

  exes = [ "image_optim" ];

  nativeBuildInputs = [ makeWrapper ];

  postBuild = ''
    wrapProgram $out/bin/image_optim \
      --prefix PATH : ${lib.escapeShellArg (makeBinPath optionalDepsPath)} \
      --add-flags "${lib.concatStringsSep " " disabledWorkersFlags}"
  '';

  passthru.updateScript = bundlerUpdateScript "image_optim";

  meta = with lib; {
    description = "Optimize images using multiple utilities";
    longDescription = ''
      Command line tool and ruby interface to optimize (lossless compress,
      optionally lossy) jpeg, png, gif and svg images using external utilities
      (advpng, gifsicle, jhead, jpeg-recompress, jpegoptim, jpegrescan,
      jpegtran, optipng, oxipng, pngcrush, pngout, pngquant, svgo)
    '';
    homepage = "https://github.com/toy/image_optim";
    license = licenses.mit;
    maintainers = with maintainers; [ srghma nicknovitski ];
    platforms = platforms.all;
  };
}
