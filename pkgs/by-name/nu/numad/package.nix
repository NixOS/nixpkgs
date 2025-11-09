{
  lib,
  stdenv,
  fetchgit,
  unstableGitUpdater,
  writeShellScript,
}:

stdenv.mkDerivation {
  pname = "numad";
  version = "0.5-unstable-2025-11-04";

  src = fetchgit {
    url = "https://pagure.io/numad.git";
    rev = "2aa0c3cf7fbc0d7a30d6355c887fedf08b77b88d";
    hash = "sha256-5KjimzjNMCmCNaoJTWjqTJrNObyb/DatSM8W70jhl0c=";
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
