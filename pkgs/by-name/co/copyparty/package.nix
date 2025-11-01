{
  lib,
  python3Packages,
  edition ? "ac",
  fetchurl,
  withCfssl ? true,
  cfssl,
  ffmpeg,
  vips,
  fftw,
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

/*
min:
RUN     apk --no-cache add !pyc \
            py3-jinja2
*/

/*
im:
RUN     apk --no-cache add !pyc \
            tzdata wget mimalloc2 mimalloc2-insecure \
            py3-jinja2 py3-argon2-cffi py3-pillow py3-mutagen
*/

/*
ac:
RUN     apk --no-cache add !pyc \
            tzdata wget mimalloc2 mimalloc2-insecure \
            py3-jinja2 py3-argon2-cffi py3-pyzmq py3-pillow \
            ffmpeg
*/

/*
iv:
RUN     apk add -U !pyc \
            tzdata wget mimalloc2 mimalloc2-insecure \
            py3-jinja2 py3-argon2-cffi py3-pyzmq py3-pillow \
            py3-pip py3-cffi \
            ffmpeg \
            py3-magic \
            vips-jxl vips-heif vips-poppler vips-magick \
        && apk add -t .bd \
            bash wget gcc g++ make cmake patchelf \
            python3-dev py3-wheel libffi-dev \
        && rm -f /usr/lib/python3* /EXTERNALLY-MANAGED \
        && python3 -m pip install pyvips \
        && apk del py3-pip .bd
*/

/*
dj:
COPY    i/bin/mtag/install-deps.sh ./
COPY    i/bin/mtag/audio-bpm.py /mtag/
COPY    i/bin/mtag/audio-key.py /mtag/
RUN     apk add -U !pyc \
            tzdata wget mimalloc2 mimalloc2-insecure \
            py3-jinja2 py3-argon2-cffi py3-pyzmq py3-pillow \
            py3-pip py3-cffi \
            ffmpeg \
            py3-magic \
            vips-jxl vips-heif vips-poppler vips-magick \
            py3-numpy fftw libsndfile \
            vamp-sdk vamp-sdk-libs \
        && apk add -t .bd \
            bash wget gcc g++ make cmake patchelf \
            python3-dev ffmpeg-dev fftw-dev libsndfile-dev \
            py3-wheel py3-numpy-dev libffi-dev \
            vamp-sdk-dev \
        && rm -f /usr/lib/python3* /EXTERNALLY-MANAGED \
        && python3 -m pip install pyvips \
        && bash install-deps.sh \
        && apk del py3-pip .bd \
        && chmod 777 /root \
        && ln -s /root/vamp /root/.local /
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
    pyftpdlib
  ] ++ (optionalsEd "im" [
    argon2-cffi
    mutagen
  ]) ++ (optionalsEd "ac" [
    pyzmq
    pillow
    pillow-heif
    pillow-avif-plugin
  ]) ++ (optionalsEd "iv" [
    cffi
    magic
  ]) ++ (optionalsEd "dj" [
    numpy
  ]));

  extraPath = (lib.optionals withCfssl [ cfssl ])
    ++ (optionalsEd "ac" [ ffmpeg ])
    ++ (optionalsEd "iv" [ vips /* vips-jxl vips-heif vips-poppler vips-magick */ ])
    ++ (optionalsEd "dj" [ fftw ]);

  makeWrapperArgs = [ "--prefix PATH : ${lib.makeBinPath extraPath}" ];

  meta = {
    description = "turn almost any device into a file server";
    homepage = "https://github.com/9001/copyparty";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [
      mkg20001
    ];
  };
}
