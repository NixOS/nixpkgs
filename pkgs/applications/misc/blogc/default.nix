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

stdenv.mkDerivation rec {
  pname = "blogc";
  version = "0.20.1";

  src = fetchFromGitHub {
    owner = "blogc";
    repo = pname;
    rev = "v${version}";
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

  meta = with lib; {
    description = "Blog compiler";
    license = licenses.bsd3;
    homepage = "https://blogc.rgm.io";
    platforms = platforms.unix;
    maintainers = with maintainers; [ sikmir ];
  };
}
