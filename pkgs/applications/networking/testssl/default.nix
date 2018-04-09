{ stdenv, fetchFromGitHub, pkgs }:

let
  version = "2.9.5-4";
  pwdBinPath = "${stdenv.lib.makeBinPath (with pkgs; [ coreutils ])}/pwd";
  opensslBinPath = "${stdenv.lib.makeBinPath (with pkgs; [ openssl ])}/openssl";

in stdenv.mkDerivation rec {
  name = "testssl.sh-${version}";

  src = fetchFromGitHub {
    owner = "drwetter";
    repo = "testssl.sh";
    rev = "v${version}";
    sha256 = "0pfp7r4jhvkh06vawqlvq7vp4imwp6dpq6jx8m0k3j85ywwp45pd";
  };

  patches = [ ./testssl.patch ];

  postPatch = ''
    substituteInPlace testssl.sh                                               \
      --replace /bin/pwd                    ${pwdBinPath}                      \
      --replace TESTSSL_INSTALL_DIR:-\"\"   TESTSSL_INSTALL_DIR:-\"$out\"      \
      --replace @@openssl-path@@            ${opensslBinPath}
  '';

  installPhase = ''
    mkdir -p $out/bin $out/etc
    cp -r etc/ $out/
    cp testssl.sh $out/bin/testssl.sh
  '';

  meta = with stdenv.lib; {
    description = "CLI tool to check a server's TLS/SSL capabilities";
    longDescription = ''
      CLI tool which checks a server's service on any port for the support of
      TLS/SSL ciphers, protocols as well as recent cryptographic flaws and more.
    '';
    homepage = https://testssl.sh/;
    license = licenses.gpl2;
    maintainers = [ maintainers.etu ];
  };
}
