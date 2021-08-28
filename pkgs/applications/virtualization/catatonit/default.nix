{ lib, stdenv, fetchFromGitHub, fetchpatch, autoreconfHook, glibc, nixosTests }:

stdenv.mkDerivation rec {
  pname = "catatonit";
  version = "0.1.5";

  src = fetchFromGitHub {
    owner = "openSUSE";
    repo = pname;
    rev = "v${version}";
    sha256 = "ciJ1MI7jr5P2PgxIykQ+BiwNUO8lQHGt0+U8CNbc5bI=";
  };

  patches = [
    # Fix compilation with musl
    (fetchpatch {
      url = "https://github.com/openSUSE/catatonit/commit/75014b1c3099245b7d0f44f24d7f6dc4888a45fd.patch";
      sha256 = "sha256-9VMNUT1U90ocjvE7EXYfLxuodDwTXXHYg89qqa5Jq0g=";
    })
  ];

  nativeBuildInputs = [ autoreconfHook ];
  buildInputs = lib.optionals (!stdenv.hostPlatform.isMusl) [ glibc glibc.static ];

  doInstallCheck = true;
  installCheckPhase = ''
    readelf -d $out/bin/catatonit | grep 'There is no dynamic section in this file.'
  '';

  passthru.tests = { inherit (nixosTests) podman; };

  meta = with lib; {
    description = "A container init that is so simple it's effectively brain-dead";
    homepage = "https://github.com/openSUSE/catatonit";
    license = licenses.gpl3Plus;
    maintainers = with maintainers; [ erosennin ] ++ teams.podman.members;
    platforms = platforms.linux;
  };
}
