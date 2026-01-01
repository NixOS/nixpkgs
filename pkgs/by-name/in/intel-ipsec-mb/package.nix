{
  lib,
  stdenv,
  fetchFromGitHub,
  nasm,
}:

<<<<<<< HEAD
stdenv.mkDerivation (finalAttrs: {
=======
stdenv.mkDerivation rec {
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
  pname = "intel-ipsec-mb";
  version = "2.0.1";

  src = fetchFromGitHub {
    owner = "intel";
    repo = "intel-ipsec-mb";
<<<<<<< HEAD
    tag = "v${finalAttrs.version}";
    hash = "sha256-k/NoPMKbiWZ25tdomsPpv2gfhQuBHxzX6KRT1UY88Ko=";
  };

  sourceRoot = "${finalAttrs.src.name}/lib";
=======
    rev = "v${version}";
    hash = "sha256-k/NoPMKbiWZ25tdomsPpv2gfhQuBHxzX6KRT1UY88Ko=";
  };

  sourceRoot = "source/lib";
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)

  nativeBuildInputs = [ nasm ];

  makeFlags = [
    "PREFIX=$(out)"
    "NOLDCONFIG=y"
  ];

<<<<<<< HEAD
  meta = {
=======
  meta = with lib; {
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
    description = "Intel Multi-Buffer Crypto for IPsec Library";
    longDescription = ''
      Intel Multi-Buffer Crypto for IPsec Library provides software crypto
      acceleration primarily targeting packet processing applications.
      It supports a variety of use cases including IPsec, TLS, wireless (RAN), cable,
      and MPEG DRM.
    '';
    homepage = "https://github.com/intel/intel-ipsec-mb";
<<<<<<< HEAD
    license = lib.licenses.bsd3;
    platforms = [ "x86_64-linux" ];
    maintainers = [ ];
  };
})
=======
    license = licenses.bsd3;
    platforms = [ "x86_64-linux" ];
    maintainers = [ ];
  };
}
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
