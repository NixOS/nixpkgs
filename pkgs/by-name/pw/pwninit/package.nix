{
  lib,
  fetchFromGitHub,
  rustPlatform,
  openssl,
  elfutils,
  makeBinaryWrapper,
  pkg-config,
  xz,
}:

rustPlatform.buildRustPackage (finalAttrs: {
  pname = "pwninit";
  version = "3.3.3";

  src = fetchFromGitHub {
    owner = "io12";
    repo = "pwninit";
    rev = finalAttrs.version;
    sha256 = "sha256-Gy7W2caZSD/fXzcGpYEzpotEAmYF48UeDUNWN4rbOTs=";
  };

  buildInputs = [
    openssl
    xz
  ];
  nativeBuildInputs = [
    pkg-config
    makeBinaryWrapper
  ];
  postInstall = ''
    wrapProgram $out/bin/pwninit \
      --prefix PATH : "${lib.getBin elfutils}/bin"
  '';
  doCheck = false; # there are no tests to run

  cargoHash = "sha256-m0Bdx2ayLCTCJXCl7YUKfxka1qUVSFm9LNLICEjEfY4=";

  meta = {
    description = "Automate starting binary exploit challenges";
    mainProgram = "pwninit";
    homepage = "https://github.com/io12/pwninit";
    license = lib.licenses.mit;
    maintainers = [ lib.maintainers.scoder12 ];
    platforms = lib.platforms.all;
  };
})
