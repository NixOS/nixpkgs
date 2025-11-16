{
  stdenv,
  lib,
  nlohmann_json,
  fetchFromGitHub,
}:

stdenv.mkDerivation {
  pname = "astm";
  version = "1.0";

  src = fetchFromGitHub {
    owner = "ritishDas";
    rev = "ff213b8e42f793ef67821ad9834c07293946c475";
    repo = "astm";
    hash = "sha256-ZBg2MHAD5CVzaG4kwO447I78x/ZZKoJw/6ZFYp5EW9w=";
  };

  nativeBuildInputs = [ stdenv.cc ];
  buildInputs = [ nlohmann_json ];

  buildPhase = ''
      mkdir -p build
    $CXX -std=c++17 -O2 astm.cpp -o build/astm
  '';

  installPhase = ''
    mkdir -p $out/bin
    install -m755 build/astm $out/bin/

    mkdir -p $out/share/bash-completion/completions
    install -m644 completions/astm.bash \
      $out/share/bash-completion/completions/astm
  '';

  meta = {
    description = "Asset Manager (astm)";
    homepage = "https://github.com/ritishDas/astm";
    license = lib.licenses.mit; # or whatever applies
    maintainers = with lib.maintainers; [ ritishDas ];
    platforms = lib.platforms.linux;
  };
}
