{ stdenv, fetchFromGitHub, pkgs }:

let
  version = "2.9.5-3";
  pwdBinPath = "${stdenv.lib.makeBinPath (with pkgs; [ coreutils ])}/pwd";
  opensslBinPath = "${stdenv.lib.makeBinPath (with pkgs; [ openssl ])}/openssl";

in stdenv.mkDerivation rec {
  name = "testssl.sh-${version}";

  src = fetchFromGitHub {
    owner = "drwetter";
    repo = "testssl.sh";
    rev = "v${version}";
    sha256 = "07vlmf3gn2xa4wam2sql6c1s1hvj5adzd6l1fl12lq066v0k7r7n";
  };

  patches = [ ./testssl.patch ];

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
