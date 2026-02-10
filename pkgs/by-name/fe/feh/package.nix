{
  lib,
  stdenv,
  fetchFromGitHub,
  makeWrapper,
  libxt,
  libxinerama,
  libx11,
  imlib2Full,
  libjpeg,
  libpng,
  curl,
  libexif,
  jpegexiforient,
  perl,
  enableAutoreload ? !stdenv.hostPlatform.isDarwin,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "feh";
  version = "3.11.2";

  src = fetchFromGitHub {
    owner = "derf";
    repo = "feh";
    rev = finalAttrs.version;
    hash = "sha256-bwp/hzkuwQTgPakE0zkNtBWrNUkVWt9btTD8MVx+Xq4=";
  };

  outputs = [
    "out"
    "man"
    "doc"
  ];

  nativeBuildInputs = [ makeWrapper ];

  buildInputs = [
    libxt
    libx11
    libxinerama
    imlib2Full
    libjpeg
    libpng
    curl
    libexif
  ];

  makeFlags = [
    "PREFIX=${placeholder "out"}"
    "exif=1"
  ]
  ++ lib.optional stdenv.hostPlatform.isDarwin "verscmp=0"
  ++ lib.optional enableAutoreload "inotify=1";

  installTargets = [ "install" ];
  postInstall = ''
    wrapProgram "$out/bin/feh" --prefix PATH : "${
      lib.makeBinPath [
        libjpeg
        jpegexiforient
      ]
    }" \
                               --add-flags '--theme=feh'
  '';

  nativeCheckInputs = lib.singleton (perl.withPackages (p: [ p.TestCommand ]));
  doCheck = true;

  meta = {
    description = "Light-weight image viewer";
    homepage = "https://feh.finalrewind.org/";
    # released under a variant of the MIT license
    # https://spdx.org/licenses/MIT-feh.html
    license = lib.licenses.mit-feh;
    maintainers = with lib.maintainers; [
      gepbird
    ];
    platforms = lib.platforms.unix;
    mainProgram = "feh";
  };
})
