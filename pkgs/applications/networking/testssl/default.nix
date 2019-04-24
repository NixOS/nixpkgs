{ stdenv, fetchFromGitHub, makeWrapper, lib
, dnsutils, coreutils, openssl, nettools, utillinux, procps }:

stdenv.mkDerivation rec {
  pname = "testssl.sh";
  version = "2.9.5-8";

  src = fetchFromGitHub {
    owner = "drwetter";
    repo = "testssl.sh";
    rev = "v${version}";
    sha256 = "1fpakzm2gsv8yva58s23lhlgxkkvi3pixil2mjrlkmr0qk66rc32";
  };

  nativeBuildInputs = [ makeWrapper ];
  buildInputs = [
    coreutils # for pwd and printf
    dnsutils  # for dig
    nettools  # for hostname
    openssl   # for openssl
    procps    # for ps
    utillinux # for hexdump
  ];

  postPatch = ''
    substituteInPlace testssl.sh                                               \
      --replace /bin/pwd                    pwd                                \
      --replace TESTSSL_INSTALL_DIR:-\"\"   TESTSSL_INSTALL_DIR:-\"$out\"
  '';

  installPhase = ''
    install -D testssl.sh $out/bin/testssl.sh
    cp -r etc $out

    wrapProgram $out/bin/testssl.sh --prefix PATH ':' ${lib.makeBinPath buildInputs}
  '';

  meta = with stdenv.lib; {
    description = "CLI tool to check a server's TLS/SSL capabilities";
    longDescription = ''
      CLI tool which checks a server's service on any port for the support of
      TLS/SSL ciphers, protocols as well as recent cryptographic flaws and more.
    '';
    homepage = https://testssl.sh/;
    license = licenses.gpl2;
    maintainers = with maintainers; [ etu ];
  };
}
