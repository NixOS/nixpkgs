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
    sha256 = "0vzff2hdng8ybwd5frflhxpak0yqg0985p1dy7vpvhr8kbqqzwdz";
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
