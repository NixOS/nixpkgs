{ stdenv, fetchFromGitHub, pkgs }:

let
  version = "2.9.5-2";
  pwdBinPath = "${stdenv.lib.makeBinPath (with pkgs; [ coreutils ])}/pwd";
  opensslBinPath = "${stdenv.lib.makeBinPath (with pkgs; [ openssl ])}/openssl";

in stdenv.mkDerivation rec {
  name = "testssl.sh-${version}";

  src = fetchFromGitHub {
    owner = "drwetter";
    repo = "testssl.sh";
    rev = "v${version}";
    sha256 = "0nrzb2lhjq0s4dabyq8nldjijsld9gq4cxm8ys1cw5jyz1875g2w";
  };

  nativeBuildInputs = with pkgs; [
    makeWrapper
  ];

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
