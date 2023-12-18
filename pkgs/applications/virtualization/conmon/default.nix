{ lib
, stdenv
, fetchFromGitHub
, fetchpatch2
, pkg-config
, glib
, glibc
, libseccomp
, systemd
, nixosTests
}:

stdenv.mkDerivation rec {
  pname = "conmon";
  version = "2.1.9";

  src = fetchFromGitHub {
    owner = "containers";
    repo = pname;
    rev = "v${version}";
    hash = "sha256-GDbCjR3UWDo/AEKO3TZq29fxO9EUfymxWtvLBikJJ04=";
  };

  patches = [
    (fetchpatch2 {
      # Fix regression with several upstream bug reports; also caused podman NixOS tests to fail
      url = "https://github.com/containers/conmon/commit/53531ac78d35aa9e18a20cfff9f30b910e25ecaa.patch";
      hash = "sha256-rbLoXDmRK8P94rrhx2r22/EHZVpCsGTWItd/GW1VqZA=";
    })
  ];

  nativeBuildInputs = [ pkg-config ];
  buildInputs = [ glib libseccomp systemd ]
    ++ lib.optionals (!stdenv.hostPlatform.isMusl) [ glibc glibc.static ];

  # manpage requires building the vendored go-md2man
  makeFlags = [ "bin/conmon" ];

  installPhase = ''
    runHook preInstall
    install -D bin/conmon -t $out/bin
    runHook postInstall
  '';

  enableParallelBuilding = true;
  strictDeps = true;

  passthru.tests = { inherit (nixosTests) cri-o podman; };

  meta = with lib; {
    changelog = "https://github.com/containers/conmon/releases/tag/${src.rev}";
    homepage = "https://github.com/containers/conmon";
    description = "An OCI container runtime monitor";
    license = licenses.asl20;
    maintainers = with maintainers; [ ] ++ teams.podman.members;
    platforms = platforms.linux;
    mainProgram = "conmon";
  };
}
