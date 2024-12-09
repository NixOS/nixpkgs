{ stdenv, lib, fetchFromGitHub, fetchpatch, openssl }:

let
  eMailSrc = fetchFromGitHub {
    owner = "deanproxy";
    repo = "eMail";
    rev = "7d23c8f508a52bd8809e2af4290417829b6bb5ae";
    sha256 = "1cxxzhm36civ6vjdgrk7mfmlzkih44kdii6l2xgy4r434s8rzcpn";
  };

  srcRoot = eMailSrc.name;

  dlibSrc = fetchFromGitHub {
    owner = "deanproxy";
    repo = "dlib";
    rev = "f62f29e918748b7cea476220f7492672be81c9de";
    sha256 = "0h34cikch98sb7nsqjnb9wl384c8ndln3m6yb1172l4y89qjg9rr";
  };

in

stdenv.mkDerivation {
  pname = "email-git";
  version = "unstable-2016-01-31";
  src = eMailSrc;

  patches = [
    # Pul patch pending upstream inclusion for -fno-common toolchain support:
    #   https://github.com/deanproxy/eMail/pull/61
    (fetchpatch {
      name = "fno-common.patch";
      url = "https://github.com/deanproxy/eMail/commit/c3c1e52132832be0e51daa6e0037d5bb79a17751.patch";
      sha256 = "17ndrb65g0v4y521333h4244419s8nncm0yx2jwv12sf0dl6gy8i";
    })
  ];

  buildInputs = [ openssl ];

  unpackPhase = ''
    unpackPhase;
    cp -Rp ${dlibSrc}/* ${srcRoot}/dlib;
    chmod -R +w ${srcRoot}/dlib;
  '';

  meta = {
    description = "Command line SMTP client";
    license = with lib.licenses; [ gpl2Plus ];
    homepage = "https://deanproxy.com/code";
    platforms = lib.platforms.unix;
    mainProgram = "email";
  };
}
