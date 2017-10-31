{ stdenv, fetchFromGitHub, pkgs }:

stdenv.mkDerivation rec {
  version = "2.9.5-1";
  name = "testssl.sh-${version}";

  src = fetchFromGitHub {
    owner = "drwetter";
    repo = "testssl.sh";
    rev = "v${version}";
    sha256 = "0hz6g685jwl0c0jrdca746425xpwiwc8lnlc2gigga5hkcq8qzl9";
  };

  nativeBuildInputs = with pkgs; [
    makeWrapper
  ];

  patches = [ ./testssl.patch ];

  pwdBinPath = "${stdenv.lib.makeBinPath (with pkgs; [ coreutils ])}/pwd";
  opensslBinPath = "${stdenv.lib.makeBinPath (with pkgs; [ openssl ])}/openssl";
  postPatch = ''
    sed -i -e "s|/bin/pwd|${pwdBinPath}|g"                                     \
           -e "s|TESTSSL_INSTALL_DIR:-\"\"|TESTSSL_INSTALL_DIR:-\"$out\"|g"    \
           -e "s|OPENSSL:-\"\"|OPENSSL:-\"${opensslBinPath}\"|g" \
           testssl.sh
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
