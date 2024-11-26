{
  lib,
  fetchFromGitHub,
  python3,
  stdenv,
  strip-nondeterminism,
  zip,
}:

let
  version = "1.1.0";
  sha256 = "sha256-563xOz63vto19yuaHtReV1dSw6BgNf+CLtS3lrPnaoc=";

  pname = "pridefetch";
  src = fetchFromGitHub {
    owner = "SpyHoodle";
    repo = pname;
    rev = "v" + version;
    inherit sha256;
  };
in

stdenv.mkDerivation {
  inherit pname version src;

  nativeBuildInputs = [
    strip-nondeterminism
    zip
  ];

  buildInputs = [
    (python3.withPackages (
      pythonPackages: with pythonPackages; [
        distro
      ]
    ))
  ];

  buildPhase = ''
    runHook preBuild
    pushd src
    zip -r ../pridefetch.zip ./*
    strip-nondeterminism ../pridefetch.zip
    popd
    echo '#!/usr/bin/env python' | cat - pridefetch.zip > pridefetch
    rm pridefetch.zip
    runHook postBuild
  '';

  installPhase = ''
    runHook preInstall
    mkdir -p $out/bin
    mv pridefetch $out/bin/pridefetch
    chmod +x $out/bin/pridefetch
    runHook postInstall
  '';

  meta = with lib; {
    description = "Print out system statistics with pride flags";
    longDescription = ''
      Pridefetch prints your system statistics (similarly to neofetch, screenfetch or pfetch) along with a pride flag.
      The flag which is printed is configurable, as well as the width of the output.
    '';
    homepage = "https://github.com/SpyHoodle/pridefetch";
    license = licenses.mit;
    maintainers = [
      maintainers.minion3665
    ];
    platforms = platforms.all;
    mainProgram = "pridefetch";
  };
}
