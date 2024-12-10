{
  stdenv,
  lib,
  fetchFromGitHub,
  fetchzip,
  libX11,
}:

let

  vst-sdk = stdenv.mkDerivation rec {
    name = "vstsdk3610_11_06_2018_build_37";
    src = fetchzip {
      url = "https://web.archive.org/web/20181016150224if_/https://download.steinberg.net/sdk_downloads/${name}.zip";
      sha256 = "0da16iwac590wphz2sm5afrfj42jrsnkr1bxcy93lj7a369ildkj";
    };
    installPhase = "cp -r . $out";
  };

in
stdenv.mkDerivation rec {
  pname = "oxefmsynth";
  version = "1.3.5";

  src = fetchFromGitHub {
    owner = "oxesoft";
    repo = pname;
    rev = "v${version}";
    sha256 = "1rk71ls33a38wx8i22plsi7d89cqqxrfxknq5i4f9igsw1ipm4gn";
  };

  env.NIX_CFLAGS_COMPILE = toString [ "-Wno-narrowing" ];

  buildFlags = [ "VSTSDK_PATH=${vst-sdk}/VST2_SDK" ];

  buildInputs = [ libX11 ];

  installPhase = ''
    mkdir -p $out/lib/lxvst
    install -Dm644 oxevst64.so -t $out/lib/lxvst
  '';

  meta = with lib; {
    homepage = "https://github.com/oxesoft/oxefmsynth";
    description = "An open source VST 2.4 instrument plugin";
    maintainers = [ maintainers.hirenashah ];
    platforms = [ "x86_64-linux" ];
    license = licenses.gpl3Only;
  };
}
