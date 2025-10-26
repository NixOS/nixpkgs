{
  stdenv,
  lib,
  fetchFromGitHub,
  unstableGitUpdater,
  libpcap,
  installShellFiles,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "choparp";
  version = "0-unstable-2021-04-23";

  src = fetchFromGitHub {
    owner = "quinot";
    repo = "choparp";
    rev = "e9f0b81135d81cb0416504a7e695e158f4a5285e";
    hash = "sha256-0VZj7Hkn/aiRddWdBzDAXdOdxJZvwd+KaN9ddrrBjm8=";
  };

  nativeBuildInputs = [
    installShellFiles
  ];

  buildPhase = ''
    runHook preBuild

    mkdir -p $out/bin
    $CC -o $out/bin/choparp src/choparp.c -lpcap -L${lib.getLib libpcap}/lib -I${lib.getDev libpcap}/include
    installManPage src/choparp.8

    runHook postBuild
  '';

  passthru.updateScript = unstableGitUpdater { hardcodeZeroVersion = true; };

  meta = {
    homepage = "https://github.com/quinot/choparp";
    description = "Proxy ARP daemon";
    maintainers = with lib.maintainers; [ bot-wxt1221 ];
    platforms = lib.platforms.unix;
    license = lib.licenses.bsd3;
    mainProgram = "choparp";
  };
})
