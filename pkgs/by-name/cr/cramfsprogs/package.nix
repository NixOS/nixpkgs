{
  lib,
  stdenv,
  fetchFromGitHub,
  zlib,
}:

stdenv.mkDerivation {
  pname = "cramfsprogs";
  version = "2.1-unstable-2025-01-27";

  src = fetchFromGitHub {
    owner = "npitre";
    repo = "cramfs-tools";
    rev = "13ad7ee1df5ce42cf9758053186554d7cb15e2cc";
    sha256 = "sha256-JlDOowJYJJNB1opNabJgYfdt0khQFsdDvzbtY/bJwRI=";
  };

  makeFlags = [
    "CC=${stdenv.cc.targetPrefix}cc"
  ];

  installPhase = ''
    install --target $out/bin -D cramfsck mkcramfs
  '';

  buildInputs = [ zlib ];

  meta = with lib; {
    description = "Tools to create, check, and extract content of CramFs images";
    homepage = "https://github.com/npitre/cramfs-tools";
    license = licenses.gpl2Plus;
    maintainers = with maintainers; [
      pamplemousse
      blitz
    ];
    platforms = platforms.linux;
  };
}
