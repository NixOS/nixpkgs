{
  lib,
  stdenv,
  fetchFromGitHub,
  libx11,
  libxdamage,
  libxrender,
  libxcomposite,
  libxext,
  installShellFiles,
  git,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "find-cursor";
  version = "1.8";

  src = fetchFromGitHub {
    owner = "arp242";
    repo = "find-cursor";
    rev = "v${finalAttrs.version}";
    sha256 = "sha256-/Dw4bOTCnpCbeI0YJ5DJ9Q2AGBognylUk7xYGn0KIA8=";
  };

  nativeBuildInputs = [
    installShellFiles
    git
  ];
  buildInputs = [
    libx11
    libxdamage
    libxrender
    libxcomposite
    libxext
  ];
  preInstall = "mkdir -p $out/share/man/man1";
  installFlags = [ "PREFIX=${placeholder "out"}" ];

  meta = {
    description = "Simple XLib program to highlight the cursor position";
    homepage = "https://github.com/arp242/find-cursor";
    license = lib.licenses.mit;
    platforms = lib.platforms.linux;
    maintainers = [ lib.maintainers.yanganto ];
    mainProgram = "find-cursor";
  };
})
