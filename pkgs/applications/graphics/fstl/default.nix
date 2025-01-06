{
  lib,
  stdenv,
  fetchFromGitHub,
  mkDerivation,
  cmake,
}:

mkDerivation rec {
  pname = "fstl";
  version = "0.10.0";

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
    hash = "sha256-z2X78GW/IeiPCnwkeLBCLjILhfMe2sT3V9Gbw4TSf4c=";
  };

  meta = {
    description = "Fastest STL file viewer";
    mainProgram = "fstl";
    homepage = "https://github.com/fstl-app/fstl";
    license = lib.licenses.mit;
    platforms = lib.platforms.linux ++ lib.platforms.darwin;
    maintainers = with lib.maintainers; [ tweber ];
  };
}
