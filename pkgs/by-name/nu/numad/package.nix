{ lib, stdenv, fetchgit, unstableGitUpdater, writeShellScript }:

stdenv.mkDerivation {
  pname = "numad";
  version = "0.5-unstable-2023-09-06";

  src = fetchgit {
    url = "https://pagure.io/numad.git";
    rev = "3399d89305b6560e27e70aff4ad9fb403dedf947";
    hash = "sha256-USEffVcakaAbilqijJmpro92ujvxbglcXxyBlntMxaI=";
  };

  postPatch = ''
    substituteInPlace Makefile --replace "install -m" "install -Dm"
  '';

  makeFlags = [ "prefix=$(out)" ];

  passthru.updateScript = unstableGitUpdater {
    tagConverter = writeShellScript "tagConverter" ''
      read tag
      test "$tag" = "0" \
        && tag=0.5; echo "$tag"
    '';
  };

  meta = with lib; {
    description = "User-level daemon that monitors NUMA topology and processes resource consumption to facilitate good NUMA resource access";
    mainProgram = "numad";
    homepage = "https://fedoraproject.org/wiki/Features/numad";
    license = licenses.lgpl21;
    platforms = platforms.linux;
    maintainers = [ ];
  };
}
