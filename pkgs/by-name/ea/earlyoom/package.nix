{
  lib,
  fetchFromGitHub,
  installShellFiles,
  pandoc,
  stdenv,
  nixosTests,
  # Boolean flags
  withManpage ? true,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "earlyoom";
  version = "1.8.2";

  src = fetchFromGitHub {
    owner = "rfjakob";
    repo = "earlyoom";
    rev = "v${finalAttrs.version}";
    hash = "sha256-HZ7llMNdx2u1a6loIFjXt5QNkYpJp8GqLKxDf9exuzE=";
  };

  outputs = [ "out" ] ++ lib.optionals withManpage [ "man" ];

  patches = [ ./0000-fix-dbus-path.patch ];

  nativeBuildInputs = lib.optionals withManpage [
    installShellFiles
    pandoc
  ];

  makeFlags = [
    "VERSION=${finalAttrs.version}"
  ];

  installPhase = ''
    runHook preInstall
    install -D earlyoom $out/bin/earlyoom
  '' + lib.optionalString withManpage ''
    installManPage earlyoom.1
  '' + ''
    runHook postInstall
  '';

  passthru.tests = {
    inherit (nixosTests) earlyoom;
  };

  meta = {
    homepage = "https://github.com/rfjakob/earlyoom";
    description = "Early OOM Daemon for Linux";
    longDescription = ''
      earlyoom checks the amount of available memory and free swap up to 10
      times a second (less often if there is a lot of free memory). By default
      if both are below 10%, it will kill the largest process (highest
      oom_score). The percentage value is configurable via command line
      arguments.
    '';
    license = lib.licenses.mit;
    mainProgram = "earlyoom";
    maintainers = with lib.maintainers; [ ];
    platforms = lib.platforms.linux;
  };
})
