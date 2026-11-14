{
  lib,
  stdenv,
  fetchFromGitHub,
  python3Packages,
  installShellFiles,
}:

stdenv.mkDerivation {
  pname = "bean-add";
  version = "0-unstable-2018-01-08";

  src = fetchFromGitHub {
    owner = "simon-v";
    repo = "bean-add";
    rev = "660c657f295b019d8dbc26375924eb17bf654341";
    hash = "sha256-v/GP8Zoow3338S3cghJ42IOpbofUZVcaXx4926Bw7m8=";
  };

  propagatedBuildInputs = with python3Packages; [ python ];

  nativeBuildInputs = [ installShellFiles ];

  postInstall = ''
    installBin bean-add
  '';

  meta = {
    homepage = "https://github.com/simon-v/bean-add/";
    description = "Beancount transaction entry assistant";
    mainProgram = "bean-add";
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [ matthiasbeyer ];
  };
}
