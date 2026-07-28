{
  lib,
  stdenv,
  fetchFromGitHub,
  installShellFiles,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "cpufetch";
  version = "1.07";

  src = fetchFromGitHub {
    owner = "Dr-Noob";
    repo = "cpufetch";
    rev = "v${finalAttrs.version}";
    sha256 = "sha256-qmT7WBWKtSWGIK/dEd3/bF1bBjqSjfkP99htfnlFLCw=";
  };

  nativeBuildInputs = [
    installShellFiles
  ];

  # Upstream Makefile bug: for x86 builds, sysctl.c is only added to
  # SOURCE on FreeBSD even though cpuid.c calls get_sys_info_by_name
  # (defined there) on darwin too. Without this the x86_64-darwin
  # build fails to link with "Undefined symbols: _get_sys_info_by_name".
  # Widen the conditional to cover Darwin alongside FreeBSD.
  patches = lib.optionals stdenv.hostPlatform.isDarwin [
    ./darwin-x86-sysctl.patch
  ];

  installPhase = ''
    runHook preInstall

    mkdir $out
    install -Dm755 cpufetch   $out/bin/cpufetch
    install -Dm644 LICENSE    $out/share/licenses/cpufetch/LICENSE
    installManPage cpufetch.1

    runHook postInstall
  '';

  meta = {
    description = "Simplistic yet fancy CPU architecture fetching tool";
    license = lib.licenses.gpl2Only;
    homepage = "https://github.com/Dr-Noob/cpufetch";
    changelog = "https://github.com/Dr-Noob/cpufetch/releases/tag/v${finalAttrs.version}";
    maintainers = with lib.maintainers; [ devhell ];
    mainProgram = "cpufetch";
  };
})
