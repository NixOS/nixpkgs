{
  lib,
  python3Packages,
  edition ? "ac",
  fetchurl,
}:

let
  editions = {
    "min" = 0;
    "im" = 1;
    "ac" = 2;
    "iv" = 3;
    "dj" = 4;
  };
in

#assert (editions ? edition);

let
  # ensure edition is valid
  selectedEdition = editions.${edition};
  minEd = ed: selectedEdition >= editions.${edition};
  optionalsEd = ed: v: lib.optionals (minEd ed) v;

/*

* [`min`](https://hub.docker.com/r/copyparty/min) (57 MiB, 20 gz) is just copyparty itself
* [`im`](https://hub.docker.com/r/copyparty/im) (70 MiB, 25 gz) can thumbnail images with pillow, parse media files with mutagen
* [`ac` (163 MiB, 56 gz)](https://hub.docker.com/r/copyparty/ac) is `im` plus ffmpeg for video/audio thumbs + audio transcoding + better tags
* [`iv`](https://hub.docker.com/r/copyparty/iv) (211 MiB, 73 gz) is `ac` plus vips for faster heif / avic / jxl thumbnails
* [`dj`](https://hub.docker.com/r/copyparty/dj) (309 MiB, 104 gz) is `iv` plus beatroot/keyfinder to detect musical keys and bpm

[`ac` is recommended](https://hub.docker.com/r/copyparty/ac) since the additional features available in `iv` and `dj` are rarely useful

*/

in

python3Packages.buildPythonApplication rec {
  pname = "copyparty";
  version = "1.18.0";
  pyproject = true;

  src = fetchurl {
    url = "https://github.com/9001/copyparty/releases/download/v${version}/copyparty-${version}.tar.gz";
    hash = "sha256-accMlrmsSgnEfMxR95MKboL1LtcnAwN0hCaBUzr8Eow=";    
  };

  build-system = with python3Packages; [
    setuptools
  ];

  dependencies = with python3Packages; ([
    jinja2
  ] ++ (optionalsEd "ac" [
    argon2-cffi
    pyzmq
    pillow
  ]));

  meta = {
    description = "turn almost any device into a file server";
    homepage = "https://github.com/9001/copyparty";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [
      mkg20001
    ];
  };
}

