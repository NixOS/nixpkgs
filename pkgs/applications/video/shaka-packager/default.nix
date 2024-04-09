{ lib
, stdenv
, fetchFromGitHub
, runCommand
, shaka-packager
, cmake
, ninja
, python3
, darwin
, nix-update-script
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "shaka-packager";
  version = "3.0.4";

  src = fetchFromGitHub {
    owner = "shaka-project";
    repo = finalAttrs.pname;
    rev = "v${finalAttrs.version}";
    hash = "sha256-SR5sFcpSbhk1W/epeXMnLfEc/pypuNAieDCzZk4DhEY=";
    # dependencies are vendored as git submodules
    fetchSubmodules = true;
  };

  patches = [ ./0001-packager-version.patch ];

  enableParallelBuilding = true;

  nativeBuildInputs = [ cmake ninja ];

  buildInputs = [ python3 ] ++ lib.optionals stdenv.isDarwin [
    darwin.apple_sdk.frameworks.SystemConfiguration
  ];

  cmakeFlags = [
    "-DPACKAGER_VERSION=v${finalAttrs.version}"
  ] ++ lib.optionals (stdenv.isDarwin && stdenv.isx86_64) [
    # required for abseil-cpp C++17 compatibility on x86_64-darwin
    "-DCMAKE_OSX_DEPLOYMENT_TARGET=10.13"
  ];

  passthru.tests = {
    simple = runCommand "${finalAttrs.pname}-test" { } ''
      ${shaka-packager}/bin/packager -version | grep ${finalAttrs.version} > $out
    '';
  };

  passthru.updateScript = nix-update-script { };

  meta = with lib; {
    description = "Media packaging framework for VOD and Live DASH and HLS applications";
    homepage = "https://shaka-project.github.io/shaka-packager/html/";
    license = licenses.bsd3;
    mainProgram = "packager";
    maintainers = with maintainers; [ niklaskorz ];
    platforms = platforms.linux ++ platforms.darwin;
  };
})
