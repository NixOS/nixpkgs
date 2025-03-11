{
  lib,
  stdenv,
  fetchFromGitHub,
  mkDerivation,
  cmake,
}:

mkDerivation rec {
  pname = "fstl";
  version = "0.11.0";

  nativeBuildInputs = [ cmake ];

  installPhase = lib.optionalString stdenv.hostPlatform.isDarwin ''
    runHook preInstall

    mkdir -p $out/Applications
    mv fstl.app $out/Applications

    runHook postInstall
  '';

  src = fetchFromGitHub {
    owner = "fstl-app";
    repo = "fstl";
    rev = "v" + version;
    hash = "sha256-6V1L5aUZQl4zAkXD7yY8Ap0+QXgogQNxaTyZAxHFqM4=";
  };

  meta = with lib; {
    description = "Fastest STL file viewer";
    mainProgram = "fstl";
    homepage = "https://github.com/fstl-app/fstl";
    license = licenses.mit;
    platforms = platforms.linux ++ platforms.darwin;
    maintainers = with maintainers; [ tweber ];
  };
}
