{
  lib,
  stdenv,
  fetchFromGitHub,
  autoreconfHook,
  pkg-config,
  ronn,
  git,
  cmocka,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "blogc";
  version = "0.20.1";

  src = fetchFromGitHub {
    owner = "blogc";
    repo = "blogc";
    rev = "v${finalAttrs.version}";
    sha256 = "sha256-YAwGgV5Vllz8JlIASbGIkdRzpciQbgPiXl5DjiSEJyE=";
  };

  nativeBuildInputs = [
    autoreconfHook
    pkg-config
  ];

  buildInputs = [
    ronn
    git
    cmocka
  ];

  configureFlags = [
    "--enable-git-receiver"
    "--enable-make"
    "--enable-runserver"
  ];

  doCheck = true;

  meta = {
    description = "Blog compiler";
    license = lib.licenses.bsd3;
    homepage = "https://blogc.rgm.io";
    platforms = lib.platforms.unix;
    maintainers = with lib.maintainers; [ sikmir ];
  };
})
