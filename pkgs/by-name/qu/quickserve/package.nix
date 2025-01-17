{
  lib,
  stdenv,
  makeWrapper,
  fetchzip,
  python3,
  python3Packages,
}:
let
  threaded_servers = python3Packages.buildPythonPackage {
    name = "threaded_servers";
    src = fetchzip {
      url = "https://xyne.archlinux.ca/projects/python3-threaded_servers/src/python3-threaded_servers-2018.6.tar.xz";
      sha256 = "1irliz90a1dk4lyl7mrfq8qnnrfad9czvbcw1spc13zyai66iyhf";
    };

    # stuff we don't care about pacserve
    doCheck = false;
  };
  wrappedPython = python3.withPackages (_: [ threaded_servers ]);
in
stdenv.mkDerivation {
  pname = "quickserve";
  version = "2018";

  dontUnpack = true;
  nativeBuildInputs = [ makeWrapper ];

  installPhase = ''
    runHook preInstall
    mkdir -p $out/bin
    makeWrapper ${wrappedPython}/bin/python $out/bin/quickserve \
      --add-flags -mThreadedServers.PeeredQuickserve
    runHook postInstall
  '';

  meta = with lib; {
    description = "Simple HTTP server for quickly sharing files";
    homepage = "https://xyne.archlinux.ca/projects/quickserve/";
    license = licenses.gpl2Only;
    maintainers = with maintainers; [ lassulus ];
    mainProgram = "quickserve";
  };
}
