{ lib, stdenv, fetchFromGitHub, fetchpatch
, pkg-config
, wrapGAppsHook3
, libX11, libXv
, udev
, SDL2
, gtk3, gtksourceview3
, alsa-lib, libao, openal, libpulseaudio
, libicns, makeWrapper, darwin
}:

let
  inherit (darwin.apple_sdk_11_0.frameworks) Cocoa OpenAL;
in
stdenv.mkDerivation {
  pname = "bsnes-hd";
  version = "10.6-beta";

  src = fetchFromGitHub {
    owner = "DerKoun";
    repo = "bsnes-hd";
    rev = "beta_10_6";
    sha256 = "0f3cd89fd0lqskzj98cc1pzmdbscq0psdjckp86w94rbchx7iw4h";
  };

  patches = [
    # Replace invocation of `sips` with an equivalent invocation of `png2icns`
    # while assembling the .app directory hierarchy in the macos build. The
    # `sips` executable isn't in our environment during the build, but
    # `png2icns` is available by way of the dependency on libicns.
    ./macos-replace-sips-with-png2icns.patch

    # During `make install` on macos the Makefile wants to move the .app into
    # the current user's home directory. This patches the Makefile such that
    # the .app ends up in $(prefix)/Applications. The $(prefix) variable will
    # be set to $out, so this will result in the .app ending up in the
    # Applications directory in the current nix profile.
    ./macos-copy-app-to-prefix.patch

    # Fix build against gcc-13:
    #   https://github.com/DerKoun/bsnes-hd/pull/124
    (fetchpatch {
      name = "gcc-13.patch";
      url = "https://github.com/DerKoun/bsnes-hd/commit/587e496f667970d60b6ea29976c171da1681388e.patch";
      hash = "sha256-7KBXh8b4xGTzgV2Pt8B1eFZHOaXcCKXKzqGOf0rFG0c=";
    })
  ];

  nativeBuildInputs = [ pkg-config ]
    ++ lib.optionals stdenv.isLinux [ wrapGAppsHook3 ]
    ++ lib.optionals stdenv.isDarwin [ libicns makeWrapper ];

  buildInputs = [ SDL2 libao ]
    ++ lib.optionals stdenv.isLinux [ libX11 libXv udev gtk3 gtksourceview3 alsa-lib openal libpulseaudio ]
    ++ lib.optionals stdenv.isDarwin [ Cocoa OpenAL ];

  enableParallelBuilding = true;

  makeFlags = [ "-C" "bsnes" "prefix=$(out)" ]
    ++ lib.optionals stdenv.isLinux [ "hiro=gtk3" ]
    ++ lib.optionals stdenv.isDarwin [ "hiro=cocoa" ];

  postInstall = lib.optionalString stdenv.isDarwin ''
    mkdir -p $out/bin
    makeWrapper $out/{Applications/bsnes.app/Contents/MacOS,bin}/bsnes
  '';

  # https://github.com/bsnes-emu/bsnes/issues/107
  preFixup = lib.optionalString stdenv.isLinux ''
    gappsWrapperArgs+=(
      --prefix GDK_BACKEND : x11
    )
  '';

  meta = with lib; {
    description = "A fork of bsnes that adds HD video features";
    homepage = "https://github.com/DerKoun/bsnes-hd";
    license = licenses.gpl3Only;
    maintainers = with maintainers; [ stevebob ];
    platforms = platforms.unix;
    mainProgram = "bsnes";
  };
}
