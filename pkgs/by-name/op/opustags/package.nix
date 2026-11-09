{
  stdenv,
  lib,
  fetchFromGitHub,
  cmake,
  pkg-config,
  libiconv,
  libogg,
  ffmpeg,
  glibcLocales,
  perl,
  perlPackages,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "opustags";
  version = "1.10.1";

  src = fetchFromGitHub {
    owner = "fmang";
    repo = "opustags";
    rev = finalAttrs.version;
    sha256 = "sha256-0lo+4VMYXGwXUuRxU1xZRxzlUQ4o4n/CDHXDM27FK44=";
  };

  nativeBuildInputs = [
    cmake
    pkg-config
  ]
  ++ lib.optionals stdenv.hostPlatform.isDarwin [ libiconv ];

  buildInputs = [ libogg ];

  doCheck = true;

  nativeCheckInputs = [
    ffmpeg
    glibcLocales
    perl
  ]
  ++ (with perlPackages; [
    ListMoreUtils
    TestDeep
  ]);

  checkPhase = ''
    export LANG="en_US.UTF-8"
    export LC_ALL="en_US.UTF-8"
    make check
  '';

  meta = {
    homepage = "https://github.com/fmang/opustags";
    description = "Ogg Opus tags editor";
    platforms = lib.platforms.all;
    broken = stdenv.hostPlatform.isDarwin;
    maintainers = with lib.maintainers; [ kmein ];
    license = lib.licenses.bsd3;
    mainProgram = "opustags";
  };
})
