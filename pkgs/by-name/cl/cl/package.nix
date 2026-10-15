{
  lib,
  stdenv,
  fetchFromGitHub,
  rebar3,
  beamPackages,
  opencl-headers,
  ocl-icd,
}:

stdenv.mkDerivation rec {
  version = "1.2.4";
  pname = "cl";

  src = fetchFromGitHub {
    owner = "tonyrog";
    repo = "cl";
    rev = "cl-${version}";
    hash = "sha256-38b9bSrW4aJ/1MQcrGJubz3dECEczPFhGAKoAgaVk78=";
  };

  # https://github.com/tonyrog/cl/issues/39
  postPatch = ''
    substituteInPlace c_src/Makefile \
      --replace-fail "-m64" ""
  '';

  buildInputs = [
    beamPackages.erlang
    rebar3
    opencl-headers
    ocl-icd
  ];

  buildPhase = ''
    rebar3 compile
  '';

  # 'cp' line taken from Arch recipe
  # https://projects.archlinux.org/svntogit/community.git/tree/trunk/PKGBUILD?h=packages/erlang-sdl
  installPhase = ''
    DIR=$out/lib/erlang/lib/${pname}-${version}
    mkdir -p $DIR
    cp -ruv c_src doc ebin include priv src $DIR
  '';

  meta = {
    homepage = "https://github.com/tonyrog/cl";
    description = "OpenCL binding for Erlang";
    license = lib.licenses.mit;
    platforms = lib.platforms.linux;
  };
}
