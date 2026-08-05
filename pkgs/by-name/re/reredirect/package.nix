{
  lib,
  stdenv,
  fetchFromGitHub,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "reredirect";
  version = "unstable-2026-02-15";

  src = fetchFromGitHub {
    owner = "jerome-pouiller";
    repo = "reredirect";
    rev = "b85df395e18d09b54e1fb73dfe344f8f04224a83";
    sha256 = "sha256-lLhF8taK6PqWo4u6pMZDN2PZavnWwsz4NbEUT7EtULo=";
  };

  makeFlags = [ "PREFIX=${placeholder "out"}" ];

  postFixup = ''
    substituteInPlace ${placeholder "out"}/bin/relink \
      --replace-fail "reredirect" "${placeholder "out"}/bin/reredirect"
  '';

  meta = {
    description = "Tool to dynamicly redirect outputs of a running process";
    homepage = "https://github.com/jerome-pouiller/reredirect";
    license = lib.licenses.mit;
    maintainers = [ lib.maintainers.tobim ];
    platforms = [
      "i686-linux"
      "x86_64-linux"
    ];
  };
})
