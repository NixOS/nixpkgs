{
  lib,
  stdenv,
  fetchFromGitHub,
  meson,
  ninja,
  nix-update-script,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "libucontext";
  version = "1.5.2";

  src = fetchFromGitHub {
    owner = "kaniini";
    repo = "libucontext";
    rev = "libucontext-${finalAttrs.version}";
    hash = "sha256-3UJmzoUgPfd2QijpGhIGmARbWClixjP5ifdH0DjEj/A=";
  };

  nativeBuildInputs = [
    meson
    ninja
  ];

  passthru.updateScript = nix-update-script { };

  meta = {
    homepage = "https://github.com/kaniini/libucontext";
    description = "ucontext implementation featuring glibc-compatible ABI";
    license = lib.licenses.isc;
    platforms = lib.platforms.linux;
    teams = [ lib.teams.lix ];
  };
})
