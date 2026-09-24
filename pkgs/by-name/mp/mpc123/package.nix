{
  lib,
  stdenv,
  fetchFromGitLab,
  gettext,
  libao,
  libmpcdec,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "mpc123";
  version = "0.2.4";

  src = fetchFromGitLab {
    domain = "salsa.debian.org";
    owner = "debian";
    repo = "mpc123";
    rev = "upstream/${finalAttrs.version}";
    hash = "sha256-+/yxb19CJzyjQmT3O21pEmPR5YudmyCxWwo+W3uOB9Q=";
  };

  strictDeps = true;

  nativeBuildInputs = [
    gettext
  ];

  buildInputs = [
    gettext
    libao
    libmpcdec
  ];

  makeFlags = [
    "CC=${stdenv.cc.targetPrefix}cc"
  ];

  # Workaround build failure on -fno-common toolchains like upstream
  # gcc-10. Otherwise build fails as:
  #   ld: /build/cc566Cj9.o:(.bss+0x0): multiple definition of `mpc123_file_reader'; ao.o:(.bss+0x40): first defined here
  env.NIX_CFLAGS_COMPILE = "-fcommon";

  # XXX: Should install locales too (though there's only 1 available).
  installPhase = ''
    runHook preInstall

    mkdir -p "$out/bin"
    cp -v mpc123 "$out/bin"

    runHook postInstall
  '';

  meta = {
    description = "Musepack (.mpc) audio player";
    homepage = "https://github.com/bucciarati/mpc123";
    license = lib.licenses.gpl2Plus;
    mainProgram = "mpc123";
    maintainers = [ ];
    platforms = lib.platforms.unix;
  };
})
