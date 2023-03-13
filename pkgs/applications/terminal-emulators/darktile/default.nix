{ stdenv
, fetchFromGitHub
, lib
, go
, pkg-config
, libX11
, libXcursor
, libXrandr
, libXinerama
, libXi
, libXext
, libXxf86vm
, libGL
, nixosTests
}:

stdenv.mkDerivation rec {
  pname = "darktile";
  version = "0.0.11";

  src = fetchFromGitHub {
    owner = "liamg";
    repo = "darktile";
    rev = "v${version}";
    sha256 = "0pr38482an4kkml2lj2xd3z4xnynx5jiix6r8wfaphlq1i4g4yrk";
  };

  nativeBuildInputs = [ go pkg-config ];

  buildInputs = [
    libX11
    libXcursor
    libXrandr
    libXinerama
    libXi
    libXext
    libXxf86vm
    libGL
  ];

  postConfigure = ''
    export GOPATH=$TMP/go
  '';

  makeFlags = [ "HOME=$TMP" ];

  installPhase = ''
    runHook preInstall

    install -Dm755 darktile -t $out/bin

    runHook postInstall
  '';

  passthru.tests.test = nixosTests.terminal-emulators.darktile;

  meta = with lib; {
    description = "A GPU rendered terminal emulator designed for tiling window managers";
    homepage = "https://github.com/liamg/darktile";
    downloadPage = "https://github.com/liamg/darktile/releases";
    changelog = "https://github.com/liamg/darktile/releases/tag/v${version}";
    license = licenses.mit;
    maintainers = with maintainers; [ flexagoon ];
  };
}
