{
  lib,
  fetchFromGitHub,
  stdenv,
  gcc,
  python312Packages,
}:
let
  version = "0.9.5-alpha";
in
stdenv.mkDerivation {
  pname = "almo";
  inherit version;

  src = fetchFromGitHub {
    owner = "abap34";
    repo = "almo";
    tag = "v${version}";
    sha256 = "sha256-Cz+XDJmdp+utzwm1c7ThTNS6kfNF6r4B16tnGQSCVMc=";
  };

  buildInputs = [
    gcc
    python312Packages.pybind11
  ];

  makeFlags = [ "all" ];

  # remove darwin-only linker flag on linux
  postPatch = lib.optionalString (!stdenv.hostPlatform.isDarwin) ''
    substituteInPlace scripts/pybind.sh \
      --replace-fail " -undefined dynamic_lookup" ""
  '';

  installPhase = ''
    runHook preInstall
    mkdir -p $out/bin $out/lib
    cp build/almo $out/bin
    cp almo.so $out/lib
    runHook postInstall
  '';

  meta = with lib; {
    description = "ALMO is markdown parser and static site generator";
    license = licenses.mit;
    platforms = platforms.all;
    homepage = "https://github.com/abap34/almo";
    maintainers = with maintainers; [ momeemt ];
    mainProgram = "almo";
  };
}
