{
  lib,
  stdenv,
  fetchgit,
  unstableGitUpdater,
}:

stdenv.mkDerivation {
  pname = "edid-decode";
  version = "0-unstable-2024-04-02";

  outputs = [
    "out"
    "man"
  ];

  src = fetchgit {
    url = "https://git.linuxtv.org/edid-decode.git";
    rev = "3d635499e4aca3319f0796ba787213c981c5a770";
    hash = "sha256-bqzO39YM/3h9p37xaGJAw9xERgWOD+4yqO/XQiq/QqM=";
  };

  preBuild = ''
    export DESTDIR=$out
    export bindir=/bin
    export mandir=/share/man
  '';

  enableParallelBuilding = true;

  passthru.updateScript = unstableGitUpdater { };

  meta = {
    description = "EDID decoder and conformance tester";
    homepage = "https://git.linuxtv.org/edid-decode.git";
    license = with lib.licenses; [ mit ];
    maintainers = with lib.maintainers; [ Madouura ];
    platforms = lib.platforms.all;
    mainProgram = "edid-decode";
  };
}
