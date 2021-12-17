{ lib, stdenv, fetchurl, makeWrapper
, xorg, imlib2, libjpeg, libpng
, curl, libexif, jpegexiforient, perl
, enableAutoreload ? !stdenv.hostPlatform.isDarwin }:

with lib;

stdenv.mkDerivation rec {
  pname = "feh";
  version = "3.7.2";

  src = fetchurl {
    url = "https://feh.finalrewind.org/${pname}-${version}.tar.bz2";
    sha256 = "sha256-hHGP0nIM9UDSRXaElP4OtOWY9Es54jJrrow2ioKcglg=";
  };

  outputs = [ "out" "man" "doc" ];

  nativeBuildInputs = [ makeWrapper xorg.libXt ];

  buildInputs = [ xorg.libX11 xorg.libXinerama imlib2 libjpeg libpng curl libexif ];

  makeFlags = [
    "PREFIX=${placeholder "out"}" "exif=1"
  ] ++ optional stdenv.isDarwin "verscmp=0"
    ++ optional enableAutoreload "inotify=1";

  installTargets = [ "install" ];
  postInstall = ''
    wrapProgram "$out/bin/feh" --prefix PATH : "${makeBinPath [ libjpeg jpegexiforient ]}" \
                               --add-flags '--theme=feh'
  '';

  checkInputs = lib.singleton (perl.withPackages (p: [ p.TestCommand ]));
  doCheck = true;

  meta = {
    description = "A light-weight image viewer";
    homepage = "https://feh.finalrewind.org/";
    license = licenses.mit;
    maintainers = with maintainers; [ viric willibutz globin ma27 ];
    platforms = platforms.unix;
  };
}
