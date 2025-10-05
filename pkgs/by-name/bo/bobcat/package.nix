{
  lib,
  stdenv,
  fetchFromGitLab,
  icmake,
  yodl,
  libmilter,
  libX11,
  openssl,
  readline,
  util-linux,
}:

stdenv.mkDerivation rec {
  pname = "bobcat";
  version = "5.11.01";

  src = fetchFromGitLab {
    domain = "gitlab.com";
    owner = "fbb-git";
    repo = "bobcat";
    tag = version;
    hash = "sha256-JLJKaJmztputIon9JkKzpm3Ch60iwm4Imh9p42crYzA=";
  };

  sourceRoot = "${src.name}/bobcat";

  postPatch = ''
    substituteInPlace INSTALL.im \
      --replace "/usr" "$out"
    sed -i "6i #include <cstdint>" logbuf/logbuf
    patchShebangs .
  '';

  strictDeps = true;

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

  buildPhase = ''
    runHook preBuild

    ./build libraries all
    ./build man

    runHook postBuild
  '';

  installPhase = ''
    runHook preInstall

    ./build install x

    runHook postInstall
  '';

  meta = with lib; {
    description = "Brokken's Own Base Classes And Templates";
    homepage = "https://fbb-git.gitlab.io/bobcat/";
    license = licenses.gpl3Only;
    platforms = platforms.linux;
  };
}
