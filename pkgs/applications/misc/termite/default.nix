{ stdenv, fetchFromGitHub, pkgconfig, vte, gtk3, ncurses, wrapGAppsHook }:

stdenv.mkDerivation rec {
  name = "termite-${version}";
  version = "13";

  src = fetchFromGitHub {
    owner = "thestinger";
    repo = "termite";
    rev = "v${version}";
    sha256 = "02cn70ygl93ghhkhs3xdxn5b1yadc255v3yp8cmhhyzsv5027hvj";
    fetchSubmodules = true;
  };

  # https://github.com/thestinger/termite/pull/516
  patches = [ ./url_regexp_trailing.patch ./add_errno_header.patch
              ] ++ stdenv.lib.optional stdenv.isDarwin ./remove_ldflags_macos.patch;

  makeFlags = [ "VERSION=v${version}" "PREFIX=" "DESTDIR=$(out)" ];

  buildInputs = [ vte gtk3 ncurses ];

  nativeBuildInputs = [ wrapGAppsHook pkgconfig ];

  outputs = [ "out" "terminfo" ];

  postInstall = ''
    mkdir -p $terminfo/share
    mv $out/share/terminfo $terminfo/share/terminfo

    mkdir -p $out/nix-support
    echo "$terminfo" >> $out/nix-support/propagated-user-env-packages
  '';

  meta = with stdenv.lib; {
    description = "A simple VTE-based terminal";
    license = licenses.lgpl2Plus;
    homepage = https://github.com/thestinger/termite/;
    maintainers = with maintainers; [ koral garbas ];
    platforms = platforms.all;
  };
}
