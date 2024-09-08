{ lib
, stdenv
, fetchFromGitHub
, m2libc
, perl
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "mescc-tools-extra";
  version = "1.3.0";

  src = fetchFromGitHub {
    owner = "oriansj";
    repo = "mescc-tools-extra";
    rev = "Release_${finalAttrs.version}";
    hash = "sha256-LS9Eq1z+OsDF7Jq0TfF4u8jEJ5bjcLZNfKtnpIbtG20=";
  };

  # Don't use vendored M2libc
  postPatch = ''
    rmdir M2libc
    ln -s ${m2libc}/include/M2libc M2libc
  '';

  enableParallelBuilding = true;

  doCheck = true;
  checkTarget = "test";
  nativeCheckInputs = [ perl ];

  installFlags = [ "PREFIX=$(out)" ];

  meta = with lib; {
    description = "Collection of tools written for use in bootstrapping";
    homepage = "https://github.com/oriansj/mescc-tools-extra";
    license = licenses.gpl3Only;
    maintainers = teams.minimal-bootstrap.members;
    inherit (m2libc.meta) platforms;
  };
})
