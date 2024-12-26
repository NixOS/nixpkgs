{
  lib,
  stdenv,
  fetchFromGitHub,
  fetchpatch,
  python3,
}:

stdenv.mkDerivation rec {
  pname = "libinjection";
  version = "3.10.0";

  src = fetchFromGitHub {
    owner = "client9";
    repo = pname;
    rev = "refs/tags/v${version}";
    sha256 = "0chsgam5dqr9vjfhdcp8cgk7la6nf3lq44zs6z6si98cq743550g";
  };

  nativeBuildInputs = [ python3 ];

  strictDeps = true;

  patches = [
    (fetchpatch {
      name = "support-python3-for-building";
      url = "https://raw.githubusercontent.com/sysown/proxysql/bed58f92917eb651b80fd8ffa627a485eb320805/deps/libinjection/update-build-py3.diff";
      hash = "sha256-SPdf57FIDDNpatWe5pjhAiZl5yPMDEv50k0Wj+eWTEM=";
    })
  ];

  postPatch = ''
    patchShebangs src
    substituteInPlace src/Makefile \
      --replace /usr/local $out
  '';

  configurePhase = "cd src";
  buildPhase = "make all";

  # no binaries, so out = library, dev = headers
  outputs = [
    "out"
    "dev"
  ];

  meta = with lib; {
    description = "SQL / SQLI tokenizer parser analyzer";
    homepage = "https://github.com/client9/libinjection";
    license = licenses.bsd3;
    platforms = platforms.all;
    maintainers = with maintainers; [ thoughtpolice ];
  };
}
