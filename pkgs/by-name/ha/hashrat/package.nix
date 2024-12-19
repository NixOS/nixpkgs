{
  lib,
  stdenv,
  fetchFromGitHub,
  fetchpatch,
}:

stdenv.mkDerivation rec {
  pname = "hashrat";
  version = "1.22";

  src = fetchFromGitHub {
    owner = "ColumPaget";
    repo = "Hashrat";
    rev = "v${version}";
    hash = "sha256-mjjK315OUUFVdUY+zcCvm7yeo7XxourR1sghWbeFT7c=";
  };

  patches = [
    # fix cross compilation by replacing hardcoded ar with AC_PROG_AR
    # https://github.com/ColumPaget/Hashrat/pull/27
    (fetchpatch {
      url = "https://github.com/ColumPaget/Hashrat/commit/a82615e02021245850a1703e613055da2520c8fd.patch";
      hash = "sha256-tjyhM2ahZBRoRP8WjyQhrI3l20oaqMtfYmOeAZVEZqU=";
    })
  ];

  configureFlags = [ "--enable-xattr" ];

  makeFlags = [ "PREFIX=$(out)" ];

  meta = with lib; {
    description = "Command-line hash-generation utility";
    mainProgram = "hashrat";
    longDescription = ''
      Hashing tool supporting md5,sha1,sha256,sha512,whirlpool,jh and hmac versions of these.
      Includes recursive file hashing and other features.
    '';
    homepage = "http://www.cjpaget.co.uk/Code/Hashrat";
    license = licenses.gpl3Plus;
    platforms = platforms.linux;
    maintainers = with maintainers; [ zendo ];
  };
}
