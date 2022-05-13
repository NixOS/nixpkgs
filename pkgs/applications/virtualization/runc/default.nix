{ lib
, fetchFromGitHub
, buildGoModule
, go-md2man
, installShellFiles
, pkg-config
, which
, libapparmor
, apparmor-parser
, libseccomp
, libselinux
, makeWrapper
, procps
, nixosTests
, fetchpatch
}:

buildGoModule rec {
  pname = "runc";
  version = "1.0.3";

  src = fetchFromGitHub {
    owner = "opencontainers";
    repo = "runc";
    rev = "v${version}";
    sha256 = "sha256-Tl/JKbIpao+FCjngPzaVkxse50zo3XQ9Mg/AdkblMcI=";
  };

  vendorSha256 = null;
  outputs = [ "out" "man" ];

  patches = [
    (fetchpatch {
      # https://github.com/opencontainers/runc/security/advisories/GHSA-f3fp-gc8g-vw66
      name = "CVE-2022-29162.patch";
      url = "https://github.com/opencontainers/runc/commit/364ec0f1b4fa188ad96049c590ecb42fa70ea165.patch";
      sha256 = "sha256-NXnM3XO+rMXIC57Gh9ovOxkfXCTsuv9MAXi2CajFurs=";
    })
  ];

  nativeBuildInputs = [ go-md2man installShellFiles makeWrapper pkg-config which ];

  buildInputs = [ libselinux libseccomp libapparmor ];

  makeFlags = [ "BUILDTAGS+=seccomp" ];

  buildPhase = ''
    runHook preBuild
    patchShebangs .
    make ${toString makeFlags} runc man
    runHook postBuild
  '';

  installPhase = ''
    runHook preInstall
    install -Dm755 runc $out/bin/runc
    installManPage man/*/*.[1-9]
    wrapProgram $out/bin/runc \
      --prefix PATH : ${lib.makeBinPath [ procps ]} \
      --prefix PATH : /run/current-system/systemd/bin
    runHook postInstall
  '';

  passthru.tests = { inherit (nixosTests) cri-o docker podman; };

  meta = with lib; {
    homepage = "https://github.com/opencontainers/runc";
    description = "A CLI tool for spawning and running containers according to the OCI specification";
    license = licenses.asl20;
    maintainers = with maintainers; [ offline ] ++ teams.podman.members;
    platforms = platforms.linux;
  };
}
