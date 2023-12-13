{ lib, stdenv, fetchFromGitHub, makeWrapper, fetchpatch
, xorg, imlib2, libjpeg, libpng
, curl, libexif, jpegexiforient, perl
, enableAutoreload ? !stdenv.hostPlatform.isDarwin }:

stdenv.mkDerivation rec {
  pname = "feh";
  version = "3.10.1";

  src = fetchFromGitHub {
    owner = "derf";
    repo = pname;
    rev = version;
    hash = "sha256-1dz04RcaoP79EoE+SsatXm2wMRCbNnmAzMECYk3y3jg=";
  };

  patches = [
    # upstream PR: https://github.com/derf/feh/pull/723
    (fetchpatch {
      name = "fix-right-click-buffer-overflow.patch";
      url = "https://github.com/derf/feh/commit/2c31f8863b80030e772a529ade519fc2fee4a991.patch";
      sha256 = "sha256-sUWS06qt1d1AyGfqKb+1BzZslYxOzur4q0ePEHcTz1g=";
    })
  ];

  outputs = [ "out" "man" "doc" ];

  nativeBuildInputs = [ makeWrapper ];

  buildInputs = [ xorg.libXt xorg.libX11 xorg.libXinerama imlib2 libjpeg libpng curl libexif ];

  makeFlags = [
    "PREFIX=${placeholder "out"}" "exif=1"
  ] ++ lib.optional stdenv.isDarwin "verscmp=0"
    ++ lib.optional enableAutoreload "inotify=1";

  installTargets = [ "install" ];
  postInstall = ''
    wrapProgram "$out/bin/feh" --prefix PATH : "${lib.makeBinPath [ libjpeg jpegexiforient ]}" \
                               --add-flags '--theme=feh'
  '';

  nativeCheckInputs = lib.singleton (perl.withPackages (p: [ p.TestCommand ]));
  doCheck = true;

  meta = with lib; {
    description = "A light-weight image viewer";
    homepage = "https://feh.finalrewind.org/";
    # released under a variant of the MIT license
    # https://spdx.org/licenses/MIT-feh.html
    license = licenses.mit-feh;
    maintainers = with maintainers; [ viric willibutz globin ];
    platforms = platforms.unix;
    mainProgram = "feh";
  };
}
