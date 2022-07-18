{ stdenv
, buildGoModule
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
  version = "0.0.10";

  src = fetchFromGitHub {
    owner = "liamg";
    repo = "darktile";
    rev = "v${version}";
    sha256 = "0pdj4yv3qrq56gb67p85ara3g8qrzw5ha787bl2ls4vcx85q7303";
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

  postPatch = ''
    substituteInPlace scripts/build.sh \
      --replace "bash" "sh"
  '';

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
