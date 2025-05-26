{
  stdenv,
  lib,
  fetchFromGitHub,
  libX11,
  vst2-sdk,
}:
stdenv.mkDerivation rec {
  pname = "oxefmsynth";
  version = "1.3.5";

  src = fetchFromGitHub {
    owner = "oxesoft";
    repo = "oxefmsynth";
    rev = "v${version}";
    sha256 = "1rk71ls33a38wx8i22plsi7d89cqqxrfxknq5i4f9igsw1ipm4gn";
  };

  env.NIX_CFLAGS_COMPILE = toString [ "-Wno-narrowing" ];

  buildFlags = [ "VSTSDK_PATH=${vst2-sdk}" ];

  buildInputs = [ libX11 ];

  installPhase = ''
    mkdir -p $out/lib/lxvst
    install -Dm644 oxevst64.so -t $out/lib/lxvst
  '';

  meta = {
    homepage = "https://github.com/oxesoft/oxefmsynth";
    description = "Open source VST 2.4 instrument plugin";
    maintainers = [ lib.maintainers.hirenashah ];
    platforms = [ "x86_64-linux" ];
    license = lib.licenses.gpl3Only;
  };
}
