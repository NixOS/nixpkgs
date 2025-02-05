{
  stdenv,
  lib,
  fetchFromGitHub,
  perl, # for tests
}:

stdenv.mkDerivation rec {
  pname = "nq";

  version = "1.0";

  src = fetchFromGitHub {
    owner = "leahneukirchen";
    repo = "nq";
    rev = "v${version}";
    hash = "sha256-gdVBSE2a4rq46o0uO9ICww6zicVgn6ykf4CeJ/MmiF4=";
  };

  nativeCheckInputs = [ perl ];

  makeFlags = [ "PREFIX=$(out)" ];

  postPatch = ''
    sed -i nqterm \
      -e 's|\bnq\b|'$out'/bin/nq|g' \
      -e 's|\bnqtail\b|'$out'/bin/nqtail|g'
  '';

  doCheck = true;

  meta = {
    description = "Unix command line queue utility";
    homepage = "https://github.com/leahneukirchen/nq";
    changelog = "https://github.com/leahneukirchen/nq/blob/v${version}/NEWS.md";
    license = lib.licenses.publicDomain;
    platforms = lib.platforms.all;
    maintainers = [ ];
  };
}
