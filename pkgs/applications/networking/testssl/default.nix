{ stdenv, fetchFromGitHub, makeWrapper, lib
, dnsutils, coreutils, openssl, nettools, utillinux, procps }:

let
  version = "2.9.5-5";

in stdenv.mkDerivation rec {
  name = "testssl.sh-${version}";

  src = fetchFromGitHub {
    owner = "drwetter";
    repo = "testssl.sh";
    rev = "v${version}";
    sha256 = "0zgj9vhd8fv3a1cn8dxqmjd8qmgryc867gq7zbvbr41lkqc06a1r";
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
    install -Dt $out/bin testssl.sh

    wrapProgram $out/bin/testssl.sh                                            \
      --prefix PATH ':' ${lib.makeBinPath buildInputs}

    cp -r etc $out
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
