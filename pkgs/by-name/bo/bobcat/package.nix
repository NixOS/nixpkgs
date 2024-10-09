{
  lib,
  fetchFromGitLab,
  icmake,
  libX11,
  libmilter,
  openssl,
  readline,
  stdenv,
  util-linux,
  yodl,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "bobcat";
  version = "5.11.01";

  src = fetchFromGitLab {
    name = "bobcat-source-${finalAttrs.version}";
    domain = "gitlab.com";
    owner = "fbb-git";
    repo = "bobcat";
    rev = finalAttrs.version;
    hash = "sha256-JLJKaJmztputIon9JkKzpm3Ch60iwm4Imh9p42crYzA=";
  };

  sourceRoot = "${finalAttrs.src.name}/bobcat";

  nativeBuildInputs = [
    icmake
    yodl
  ];

  buildInputs = [
    libmilter
    libX11
    openssl
    readline
    util-linux
  ];

  strictDeps = true;

  postPatch = ''
    substituteInPlace INSTALL.im \
      --replace "/usr" "$out"
    sed -i "6i #include <cstdint>" logbuf/logbuf
    patchShebangs .
  '';

  buildPhase = ''
    runHook preBuild

    ./build libraries all
    ./build man

    runHook postBuild
  '';

  installPhase = ''
    runHook preBuild

    ./build install x

    runHook postBuild
  '';

  meta = {
    homepage = "https://fbb-git.gitlab.io/bobcat/";
    description = "Brokken's Own Base Classes And Templates";
    license = lib.licenses.gpl3Only;
    maintainers = with lib.maintainers; [ AndersonTorres ];
    platforms = lib.platforms.linux;
  };
})
