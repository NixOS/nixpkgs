{ stdenv, fetchurl, makeWrapper
, xorg, imlib2, libjpeg, libpng
, curl, libexif, jpegexiforient, perlPackages
, enableAutoreload ? !stdenv.hostPlatform.isDarwin }:

with stdenv.lib;

stdenv.mkDerivation rec {
  pname = "feh";
  version = "3.5";

  src = fetchurl {
    url = "https://feh.finalrewind.org/${pname}-${version}.tar.bz2";
    sha256 = "07jklibpi4ig9pbdrwhllsfffxn2h8xf4ma36qii00w4hb69v3rq";
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

  checkInputs = [ perlPackages.perl perlPackages.TestCommand ];
  preCheck = ''
    export PERL5LIB="${perlPackages.TestCommand}/${perlPackages.perl.libPrefix}"
  '';
  postCheck = ''
    unset PERL5LIB
  '';

  doCheck = true;

  meta = {
    description = "A light-weight image viewer";
    homepage = "https://feh.finalrewind.org/";
    license = licenses.mit;
    maintainers = with maintainers; [ viric willibutz globin ma27 ];
    platforms = platforms.unix;
  };
}
