{
  lib,
  stdenv,
  fetchFromGitLab,
  makeWrapper,
  gcc,
  ncurses,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "icmake";
  version = "13.02.00";

  src = fetchFromGitLab {
    owner = "fbb-git";
    repo = "icmake";
    tag = finalAttrs.version;
    hash = "sha256-bD7ykaO8ZZ1Gwpj+dpTsaJxLnf4hsJLXJK/7cCc/h6M=";
  };

  setSourceRoot = ''
    sourceRoot=$(echo */icmake)
  '';

  postPatch = ''
    patchShebangs .
    substituteInPlace buildscripts/multicomp \
      --replace-fail "/usr/bin/g++" "$CXX -std=c++23"
    substituteInPlace INSTALL.im \
      --replace-fail "usr/" ""
  '';

  nativeBuildInputs = [ makeWrapper ];

  buildInputs = [ gcc ];

  hardeningDisable = [ "fortify" ];

  env.CXXFLAGS = "-std=c++23";

  buildPhase = ''
    runHook preBuild

    ./prepare $out
    ./buildlib x
    ./build all

    runHook postBuild
  '';

  installPhase = ''
    runHook preInstall

    ./install all / || true
    mkdir -p $out
    cp -r tmp/usr/* $out
    wrapProgram $out/bin/icmbuild \
      --prefix PATH : ${ncurses}/bin

    runHook postInstall
  '';

  meta = {
    description = "Program maintenance (make) utility using a C-like grammar";
    homepage = "https://fbb-git.gitlab.io/icmake/";
    license = lib.licenses.gpl3Plus;
    maintainers = with lib.maintainers; [ pSub ];
    platforms = lib.platforms.linux;
  };
})
