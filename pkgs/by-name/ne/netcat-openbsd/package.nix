{
  lib,
  stdenv,
  fetchFromGitLab,
  pkg-config,
  libbsd,
  installShellFiles,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "netcat-openbsd";
  version = "1.234-1";

  src = fetchFromGitLab {
    domain = "salsa.debian.org";
    owner = "debian";
    repo = "netcat-openbsd";
    tag = "debian/${finalAttrs.version}";
    hash = "sha256-6pCsBbS2IjXyXgNXURHK3uMRTJ0aXAsu29kc7f479Os=";
  };

  strictDeps = true;
  nativeBuildInputs = [
    pkg-config
    installShellFiles
  ];
  buildInputs = [ libbsd ];

  postPatch = ''
    for file in $(cat debian/patches/series); do
      patch -p1 < debian/patches/$file
    done
  '';

  installPhase = ''
    runHook preInstall

    install -Dm755 -t $out/bin nc
    installManPage nc.1

    runHook postInstall
  '';

  doInstallCheck = true;
  installCheckPhase = ''
    $out/bin/nc -h 2> /dev/null
  '';

  meta = {
    description = "TCP/IP swiss army knife. OpenBSD variant";
    homepage = "https://salsa.debian.org/debian/netcat-openbsd";
    maintainers = with lib.maintainers; [ artturin ];
    license = lib.licenses.bsd3;
    platforms = lib.platforms.unix;
    mainProgram = "nc";
    # never built on aarch64-darwin, x86_64-darwin since first introduction in nixpkgs
    broken = stdenv.hostPlatform.isDarwin;
  };
})
