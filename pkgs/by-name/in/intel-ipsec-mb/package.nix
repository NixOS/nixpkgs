{
  lib,
  stdenv,
  fetchFromGitHub,
  nasm,
}:

stdenv.mkDerivation rec {
  pname = "intel-ipsec-mb";
  version = "2.0.1";

  src = fetchFromGitHub {
    owner = "intel";
    repo = "intel-ipsec-mb";
    rev = "v${version}";
    hash = "sha256-k/NoPMKbiWZ25tdomsPpv2gfhQuBHxzX6KRT1UY88Ko=";
  };

  sourceRoot = "source/lib";

  nativeBuildInputs = [ nasm ];

  makeFlags = [
    "PREFIX=$(out)"
    "NOLDCONFIG=y"
  ];

  meta = with lib; {
    description = "Intel Multi-Buffer Crypto for IPsec Library";
    longDescription = ''
      Intel Multi-Buffer Crypto for IPsec Library provides software crypto
      acceleration primarily targeting packet processing applications.
      It supports a variety of use cases including IPsec, TLS, wireless (RAN), cable,
      and MPEG DRM.
    '';
    homepage = "https://github.com/intel/intel-ipsec-mb";
    license = licenses.bsd3;
    platforms = [ "x86_64-linux" ];
    maintainers = [ ];
  };
}
