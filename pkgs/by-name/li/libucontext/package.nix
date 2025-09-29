{
  lib,
  stdenv,
  fetchFromGitHub,
  meson,
  ninja,
  nix-update-script,
}:

stdenv.mkDerivation rec {
  pname = "libucontext";
  version = "1.3.2";

  src = fetchFromGitHub {
    owner = "kaniini";
    repo = "libucontext";
    rev = "libucontext-${version}";
    hash = "sha256-aBmGt8O/HTWM9UJMKWz37uDLDkq1JEYTUb1SeGu9j9M=";
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
}
