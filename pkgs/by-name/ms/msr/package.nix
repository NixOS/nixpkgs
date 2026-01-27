{
  lib,
  stdenv,
  fetchzip,
  installShellFiles,
}:

stdenv.mkDerivation rec {
  pname = "msr";
  version = "20060208";

  src = fetchzip {
    inherit pname version;
    url = "http://www.etallen.com/msr/msr-${version}.src.tar.gz";
    hash = "sha256-e01qYWbOALkXp5NpexuVodMxA3EBySejJ6ZBpZjyT+E=";
  };

  nativeBuildInputs = [
    installShellFiles
  ];

  patches = [
    ./000-include-sysmacros.patch
  ];

  installPhase = ''
    runHook preInstall
    mkdir -p $out/bin/
    cp msr $out/bin/
    installManPage msr.man
    runHook postInstall
  '';

  meta = {
    homepage = "http://www.etallen.com/msr.html";
    description = "Linux tool to display or modify x86 model-specific registers (MSRs)";
    mainProgram = "msr";
    license = lib.licenses.bsd0;
    maintainers = [ ];
    platforms = [
      "i686-linux"
      "x86_64-linux"
    ];
  };
}
