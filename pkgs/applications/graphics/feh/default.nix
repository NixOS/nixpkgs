{ lib
, stdenv
, fetchFromGitHub
, makeWrapper
, xorg
, imlib2
, libjpeg
, libpng
, curl
, libexif
, jpegexiforient
, perl
, enableAutoreload ? !stdenv.hostPlatform.isDarwin
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "feh";
  version = "3.10.2";

  src = fetchFromGitHub {
    owner = "derf";
    repo = "feh";
    rev = finalAttrs.version;
    hash = "sha256-378rhZhpcua3UbsY0OcGKGXdMIQCuG84YjJ9vfJhZVs=";
  };

  outputs = [ "out" "man" "doc" ];

  nativeBuildInputs = [ makeWrapper ];

  buildInputs = [ xorg.libXt xorg.libX11 xorg.libXinerama imlib2 libjpeg libpng curl libexif ];

  makeFlags = [
    "PREFIX=${placeholder "out"}"
    "exif=1"
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
    maintainers = with maintainers; [ gepbird globin viric willibutz ];
    platforms = platforms.unix;
    mainProgram = "feh";
  };
})
