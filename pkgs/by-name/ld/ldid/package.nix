{
  lib,
  stdenv,
  fetchgit,
  libplist,
  libxml2,
  openssl,
}:

stdenv.mkDerivation rec {
  pname = "ldid";
  version = "2.1.5";

  src = fetchgit {
    url = "git://git.saurik.com/ldid.git";
    rev = "v${version}";
    hash = "sha256-RM5pU3mrgyvwNfWKNvCT3UYVGKtVhD7ifgp8fq9xXiM=";
  };

  strictDeps = true;

  buildInputs = [
    libplist
    libxml2
    openssl
  ];

  env.NIX_LDFLAGS = toString ([
    "-lcrypto"
    "-lplist-2.0"
  ]);

  buildPhase = ''
    runHook preBuild

    cc -c -o lookup2.o lookup2.c -I.
    c++ -std=c++11 -o ldid lookup2.o ldid.cpp -I.

    runHook postBuild
  '';

  installPhase = ''
    runHook preInstall

    install -Dm755 {,$out/bin/}ldid
    ln -s $out/bin/ldid $out/bin/ldid2

    runHook postInstall
  '';

  meta = with lib; {
    description = "Link Identity Editor";
    homepage = "https://cydia.saurik.com/info/ldid/";
    maintainers = with maintainers; [ wegank ];
    platforms = platforms.unix;
    license = licenses.agpl3Only;
  };
}
