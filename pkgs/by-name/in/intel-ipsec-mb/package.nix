{
  lib,
  stdenv,
  fetchFromGitHub,
  nasm,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "intel-ipsec-mb";
  version = "2.0.2";

  src = fetchFromGitHub {
    owner = "intel";
    repo = "intel-ipsec-mb";
    tag = "v${finalAttrs.version}";
    hash = "sha256-ClNzjFDrzX571FVV/jzlM3Sflvs33bttB2pdlhudX8o=";
  };

  sourceRoot = "${finalAttrs.src.name}/lib";

  nativeBuildInputs = [ nasm ];

  makeFlags = [
    "PREFIX=$(out)"
    "NOLDCONFIG=y"
  ];

  meta = {
    description = "Intel Multi-Buffer Crypto for IPsec Library";
    longDescription = ''
      Intel Multi-Buffer Crypto for IPsec Library provides software crypto
      acceleration primarily targeting packet processing applications.
      It supports a variety of use cases including IPsec, TLS, wireless (RAN), cable,
      and MPEG DRM.
    '';
    homepage = "https://github.com/intel/intel-ipsec-mb";
    license = lib.licenses.bsd3;
    platforms = [ "x86_64-linux" ];
    maintainers = [ ];
  };
})
