{
  lib,
  stdenv,
  fetchFromGitHub,
  zlib,
  ncompress,
  which,
  nix-update-script,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "pigz";
  version = "2.8";

  src = fetchFromGitHub {
    owner = "madler";
    repo = "pigz";
    tag = "v${finalAttrs.version}";
    sha256 = "sha256-PzdxyO4mCg2jE/oBk1MH+NUdWM95wIIIbncBg71BkmQ=";
  };

  strictDeps = true;
  __structuredAttrs = true;
  enableParallelBuilding = true;

  outputs = [
    "out"
    "doc"
    "man"
  ];

  makeFlags = [ "CC=${lib.getExe stdenv.cc}" ];
  buildInputs = [
    zlib
  ];

  doCheck = stdenv.hostPlatform.isLinux;
  checkTarget = "tests";
  nativeCheckInputs = [
    which
    ncompress
  ];

  installPhase = ''
    runHook preInstall

    install -Dm755 pigz "$out/bin/pigz"
    ln -s pigz "$out/bin/unpigz"
    install -Dm755 pigz.1 "$man/share/man/man1/pigz.1"
    ln -s pigz.1 "$man/share/man/man1/unpigz.1"
    install -Dm755 pigz.pdf "$doc/share/doc/pigz/pigz.pdf"

    runHook postInstall
  '';

  passthru = {
    updateScript = nix-update-script { };
  };

  meta = {
    homepage = "https://www.zlib.net/pigz/";
    description = "Parallel implementation of gzip for multi-core machines";
    mainProgram = "pigz";
    maintainers = with lib.maintainers; [
      sandarukasa
    ];
    license = lib.licenses.zlib;
    platforms = lib.platforms.unix;
  };
})
