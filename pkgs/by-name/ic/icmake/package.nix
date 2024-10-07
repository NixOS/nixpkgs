{
  lib,
  fetchFromGitLab,
  makeWrapper,
  ncurses,
  stdenv,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "icmake";
  version = "9.03.01";

  src = fetchFromGitLab {
    owner = "fbb-git";
    repo = "icmake";
    rev = finalAttrs.version;
    hash = "sha256-XqIwIqgqVuKpee9F0kQue4tbKWh9iXUlxGJDwJNRIBc=";
  };

  nativeBuildInputs = [ makeWrapper ];

  sourceRoot = "${finalAttrs.src.name}/icmake";

  strictDeps = true;

  postPatch = ''
    patchShebangs ./
    substituteInPlace INSTALL.im \
      --replace-fail "usr/" ""
  '';

  buildPhase = ''
    runHook preBuild

    ./icm_prepare $out
    ./icm_bootstrap x

    runHook postBuild
  '';

  installPhase = ''
    runHook preInstall

    ./icm_install all /

    wrapProgram $out/bin/icmbuild \
      --prefix PATH : ${lib.getBin ncurses}/bin

    runHook postInstall
  '';

  meta = {
    homepage = "https://fbb-git.gitlab.io/icmake/";
    description = "Program maintenance utility using a C-like grammar";
    longDescription = ''
      Icmake can be used as an alternative to make(1).

      Icmake allows the programmer to use a program language (closely resembling
      the well-known C-programming language) to define the actions involved in
      (complex) program maintenance. For this, icmake offers various special
      operators as well as a set of support functions that have proven to be
      useful in program maintenance.

      Traditional make-utilities recompile sources once header files are
      modified. In the context of C++ program development this is often a bad
      idea, as adding a new member to a class does not normally require you to
      recompile the class's sources. To handle class dependencies in a more
      sensible way, icmake's CLASSES file may define dependencies among
      classes. By default, class-dependencies are not interpreted.
    '';
    license = lib.licenses.gpl3;
    mainProgram = "icmake";
    maintainers = with lib.maintainers; [
      pSub
      AndersonTorres
    ];
    platforms = lib.platforms.all;
  };
})
