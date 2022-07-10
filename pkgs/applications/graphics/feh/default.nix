{ lib, stdenv, fetchFromGitHub, makeWrapper
, xorg, imlib2, libjpeg, libpng, fetchpatch
, curl, libexif, jpegexiforient, perl
, enableAutoreload ? !stdenv.hostPlatform.isDarwin }:

stdenv.mkDerivation rec {
  pname = "feh";
  version = "3.9";

  src = fetchFromGitHub {
    owner = "derf";
    repo = pname;
    rev = version;
    sha256 = "sha256-rgNC4M1TJ5EPeWmVHVzgaxTGLY7CYQf7uOsOn5bkwKE=";
  };

  patches = [
    # fix test failure when magic=0 is set
    (fetchpatch {
      url = "https://github.com/derf/feh/commit/3c1076b31e2e4e3429a5c3d334d555e549fb72d2.patch";
      sha256 = "sha256-F9N+N/BAeclyPHQYlO9ZV1U8S1VWfHl/8dMKUqA7DF8=";
    })
  ];

  outputs = [ "out" "man" "doc" ];

  nativeBuildInputs = [ makeWrapper xorg.libXt ];

  buildInputs = [ xorg.libX11 xorg.libXinerama imlib2 libjpeg libpng curl libexif ];

  makeFlags = [
    "PREFIX=${placeholder "out"}" "exif=1"
  ] ++ lib.optional stdenv.isDarwin "verscmp=0"
    ++ lib.optional enableAutoreload "inotify=1";

  installTargets = [ "install" ];
  postInstall = ''
    wrapProgram "$out/bin/feh" --prefix PATH : "${lib.makeBinPath [ libjpeg jpegexiforient ]}" \
                               --add-flags '--theme=feh'
  '';

  checkInputs = lib.singleton (perl.withPackages (p: [ p.TestCommand ]));
  doCheck = true;

  meta = with lib; {
    description = "A light-weight image viewer";
    homepage = "https://feh.finalrewind.org/";
    # released under a variant of the MIT license
    # https://spdx.org/licenses/MIT-feh.html
    license = licenses.mit-feh;
    maintainers = with maintainers; [ viric willibutz globin ma27 ];
    platforms = platforms.unix;
  };
}
