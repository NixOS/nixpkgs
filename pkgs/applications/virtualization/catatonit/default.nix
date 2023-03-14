{ lib, stdenv, fetchFromGitHub, fetchpatch, autoreconfHook, glibc, nixosTests }:

stdenv.mkDerivation rec {
  pname = "catatonit";
  version = "0.1.7";

  src = fetchFromGitHub {
    owner = "openSUSE";
    repo = pname;
    rev = "v${version}";
    sha256 = "sha256-jX4fYC/rpfd3ro2UZ6OEu4kU5wpusOwmEVPWEjxwlW4=";
  };

  patches = [
    # Pull the fix pending upstream inclusion to support automake-1.16.5:
    #  https://github.com/openSUSE/catatonit/pull/18
    (fetchpatch {
      name = "automake-1.16.5.patch";
      url = "https://github.com/openSUSE/catatonit/commit/99bb9048f532257f3a2c3856cfa19fe957ab6cec.patch";
      sha256 = "sha256-ooxVjtWXJddQiBvO9I5aRyLeL8y3ecxW/Kvtfg/bpRA=";
    })
  ];

  nativeBuildInputs = [ autoreconfHook ];
  buildInputs = lib.optionals (!stdenv.hostPlatform.isMusl) [ glibc glibc.static ];

  enableParallelBuilding = true;
  strictDeps = true;

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
