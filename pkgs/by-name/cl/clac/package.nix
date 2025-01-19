{
  lib,
  stdenv,
  fetchFromGitHub,
}:

stdenv.mkDerivation rec {
  pname = "clac";
  version = "0.3.3-unstable-2021-09-06";

  src = fetchFromGitHub {
    owner = "soveran";
    repo = "clac";
    rev = "beae8c4bc89912f4cd66bb875585fa471692cd54";
    sha256 = "XaULDkFF9OZW7Hbh60wbGgvCJ6L+3gZNGQ9uQv3G0zU=";
  };

  makeFlags = [ "PREFIX=$(out)" ];

  postInstall = ''
    mkdir -p "$out/share/doc/clac"
    cp README* LICENSE "$out/share/doc/clac"
  '';

  meta = {
    description = "Interactive stack-based calculator";
    homepage = "https://github.com/soveran/clac";
    license = lib.licenses.bsd2;
    maintainers = with lib.maintainers; [ raskin ];
    platforms = lib.platforms.unix;
    mainProgram = "clac";
  };
}
