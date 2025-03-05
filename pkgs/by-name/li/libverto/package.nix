{ lib
, stdenv
, fetchFromGitHub
, autoreconfHook
, glib
, libev
, libevent
, pkg-config
, glibSupport ? true
, libevSupport ? true
, libeventSupport ? true
}:

let
  inherit (lib) optional;
in
stdenv.mkDerivation (finalAttrs: {
  pname = "libverto";
  version = "0.3.2";

  src = fetchFromGitHub {
    owner = "latchset";
    repo = "libverto";
    rev = finalAttrs.version;
    hash = "sha256-csoJ0WdKyrza8kBSMKoaItKvcbijI6Wl8nWCbywPScQ=";
  };

  nativeBuildInputs = [
    autoreconfHook
    pkg-config
  ];

  buildInputs =
    optional glibSupport glib
    ++ optional libevSupport libev
    ++ optional libeventSupport libevent;

  meta = with lib; {
    homepage = "https://github.com/latchset/libverto";
    description = "Asynchronous event loop abstraction library";
    longDescription = ''
      Libverto exists to solve an important problem: many applications and
      libraries are unable to write asynchronous code because they are unable to
      pick an event loop. This is particularly true of libraries who want to be
      useful to many applications who use loops that do not integrate with one
      another or which use home-grown loops. libverto provides a loop-neutral
      async api which allows the library to expose asynchronous interfaces and
      offload the choice of the main loop to the application.
    '';
    license = licenses.mit;
    maintainers = with maintainers; [ AndersonTorres ];
    platforms = platforms.unix;
  };
})
