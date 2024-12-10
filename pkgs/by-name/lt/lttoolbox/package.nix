{
  lib,
  stdenv,
  fetchFromGitHub,
  fetchpatch,
  autoconf,
  automake,
  pkg-config,
  utf8cpp,
  libtool,
  libxml2,
  icu,
  python3,
}:

stdenv.mkDerivation rec {
  pname = "lttoolbox";
  version = "3.7.1";

  src = fetchFromGitHub {
    owner = "apertium";
    repo = "lttoolbox";
    rev = "refs/tags/v${version}";
    hash = "sha256-3lHXKtwQSrMGQEGOGr27e3kB2qKkTFZcEzeAnIm89Rg=";
  };

  patches = [
    # can be removed once the version goes past this commit
    # https://github.com/apertium/lttoolbox/commit/e682fe18a96d5a865cfbd3e5661dbc7b3ace1821
    (fetchpatch {
      url = "https://github.com/apertium/lttoolbox/commit/e682fe18a96d5a865cfbd3e5661dbc7b3ace1821.patch";
      hash = "sha256-VeP8Mv2KYxX+eVjIRw/jHbURaWN665+fiFaoT3VxAno=";
    })
  ];

  nativeBuildInputs = [
    autoconf
    automake
    pkg-config
    utf8cpp
    libtool
  ];
  buildInputs = [
    libxml2
    icu
  ];
  buildFlags = [
    "CPPFLAGS=-I${utf8cpp}/include/utf8cpp"
  ];
  configurePhase = ''
    ./autogen.sh --prefix $out
  '';
  doCheck = true;
  checkPhase = ''
    ${python3}/bin/python3 tests/run_tests.py
  '';

  meta = with lib; {
    description = "Finite state compiler, processor and helper tools used by apertium";
    homepage = "https://github.com/apertium/lttoolbox";
    maintainers = with maintainers; [ onthestairs ];
    changelog = "https://github.com/apertium/lttoolbox/releases/tag/v${version}";
    license = licenses.gpl2;
    platforms = platforms.linux ++ platforms.darwin;
  };
}
