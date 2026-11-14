{
  lib,
  stdenv,
  fetchFromGitHub,
  nix-update-script,
  cmake,
  jdk,
  portaudio,
}:
stdenv.mkDerivation {
  pname = "jportaudio";
  version = "0-unstable-2023-07-04";

  src = fetchFromGitHub {
    owner = "philburk";
    repo = "portaudio-java";
    rev = "2ec5cc47d6f8abe85ddb09c34e69342bfe72c60b";
    hash = "sha256-t+Pqtgstd1uJjvD4GKomZHMeSECNLeQJOrz97o+lV2Q=";
  };

  strictDeps = true;

  nativeBuildInputs = [ cmake ];

  buildInputs = [
    jdk
    portaudio
  ];

  postPatch = ''
    # Remove when https://github.com/philburk/portaudio-java/pull/10 is merged
    substituteInPlace CMakeLists.txt \
      --replace-fail "cmake_minimum_required(VERSION 3.2)" "cmake_minimum_required(VERSION 3.10)"
  '';

  postInstall = ''
    # Create symlink for compatiblity
    find $out/lib -type f -name "libjportaudio_*.so" \
      -exec ln -s {} $out/lib/libjportaudio.so \;
  '';

  passthru = {
    updateScript = nix-update-script { extraArgs = [ "--version=branch" ]; };
  };

  meta = {
    description = "Java binding for the PortAudio audio I/O library";
    homepage = "https://github.com/philburk/portaudio-java";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ ungeskriptet ];
  };
}
