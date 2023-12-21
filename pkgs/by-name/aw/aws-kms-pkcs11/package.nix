{ stdenv
, lib
, fetchFromGitHub
, aws-sdk-cpp
, json_c
, openssl
, p11-kit
, pkg-config
}:
stdenv.mkDerivation rec {
  pname = "aws-kms-pkcs11";
  version = "0.0.11";

  src = fetchFromGitHub {
    owner = "JackOfMostTrades";
    repo = pname;
    rev = "v${version}";
    sha256 = "sha256-diQl1UzrL4fRIY+eEwusScAgO2d7Pp1jsY4F//RyXik=";
  };
  patches = [ ./fix-up-includes.patch ];

  buildInputs = [ aws-sdk-cpp json_c openssl p11-kit pkg-config ];
  buildPhase = ''
    g++ -g -shared -fPIC -Wall -o aws_kms_pkcs11.so \
      attributes.cpp aws_kms_pkcs11.cpp certificates.cpp unsupported.cpp debug.cpp aws_kms_slot.cpp \
      $(pkg-config --cflags --libs aws-cpp-sdk-core aws-cpp-sdk-kms aws-cpp-sdk-acm-pca json-c openssl p11-kit-1)
  '';
  installPhase = ''
    install -Dm 0755 aws_kms_pkcs11.so $out/lib/pkcs11/aws_kms_pkcs11.so
  '';

  meta = with lib; {
    description = "PKCS#11 provider using AWS KMS";
    homepage = "https://github.com/JackOfMostTrades/aws-kms-pkcs11";
    license = licenses.mit;
    maintainers = with maintainers; [ iliana ];
    platforms = platforms.all;
  };
}
