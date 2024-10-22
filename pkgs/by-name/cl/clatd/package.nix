{ lib
, stdenv
, fetchFromGitHub
, makeWrapper
, perl
, perlPackages
, tayga
, iproute2
, iptables
, nixosTests
}:

stdenv.mkDerivation rec {
  pname = "clatd";
  version = "1.6";

  src = fetchFromGitHub {
    owner = "toreanderson";
    repo = "clatd";
    rev = "v${version}";
    hash = "sha256-ZUGWQTXXgATy539NQxkZSvQA7HIWkIPsw1NJrz0xKEg=";
  };

  strictDeps = true;

  nativeBuildInputs = [
    makeWrapper
    perl # for pod2man
  ];

  buildInputs = with perlPackages; [
    perl
    NetIP
    NetDNS
  ];

  makeFlags = [ "PREFIX=$(out)" ];

  preBuild = ''
    mkdir -p $out/{sbin,share/man/man8}
  '';

  postFixup = ''
    patchShebangs $out/bin/clatd
    wrapProgram $out/bin/clatd \
      --set PERL5LIB $PERL5LIB \
      --prefix PATH : ${
        lib.makeBinPath [
          tayga
          iproute2
          iptables
        ]
      }
  '';

  passthru.tests.clatd = nixosTests.clatd;

  meta = with lib; {
    description = "464XLAT CLAT implementation for Linux";
    homepage = "https://github.com/toreanderson/clatd";
    license = licenses.mit;
    maintainers = with maintainers; [ jmbaur ];
    mainProgram = "clatd";
    platforms = platforms.linux;
  };
}
