{
  lib,
  stdenv,
  fetchFromGitHub,
  openssl,
  pandoc,
  which,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "bdsync";
  version = "0.11.4";

  src = fetchFromGitHub {
    owner = "rolffokkens";
    repo = "bdsync";
    rev = "v${finalAttrs.version}";
    sha256 = "sha256-uvP26gdyIPC+IHxO5CYVuabfT4mnoWDOyaLTplYCW0I=";
  };

  nativeBuildInputs = [
    pandoc
    which
  ];
  buildInputs = [ openssl ];

  postPatch = ''
    patchShebangs ./tests.sh
    patchShebangs ./tests/
  '';

  doCheck = true;

  installPhase = ''
    install -Dm755 bdsync -t $out/bin/
    install -Dm644 bdsync.1 -t $out/share/man/man1/
  '';

  meta = {
    description = "Fast block device synchronizing tool";
    homepage = "https://github.com/rolffokkens/bdsync";
    license = lib.licenses.gpl2Only;
    platforms = lib.platforms.linux;
    maintainers = with lib.maintainers; [ jluttine ];
    mainProgram = "bdsync";
  };
})
