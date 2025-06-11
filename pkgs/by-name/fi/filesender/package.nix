{
  stdenv,
  fetchFromGitHub,
  lib,
  nixosTests,
}:
stdenv.mkDerivation (finalAttrs: {
  pname = "filesender";
  version = "2.55";

  src = fetchFromGitHub {
    owner = "filesender";
    repo = "filesender";
    tag = "filesender-${finalAttrs.version}";
    hash = "sha256-+tcf8+QDE0ML2AVC1Aj3qD74eys5dqKFPb5rkY4scRA=";
  };

  patches = [
    # /nix/store is read-only, but filesender searches config and logs inside of installation directory.
    # This patch changes search directories to FILESENDER_CONFIG_DIR and FILESENDER_LOG_DIR environment variables.
    ./separate_mutable_paths.patch
  ];

  installPhase = ''
    runHook preInstall

    mkdir -p $out/
    cp -R . $out/

    runHook postInstall
  '';

  passthru.tests = {
    inherit (nixosTests) filesender;
  };

  meta = {
    description = "Web application for sending large files to other users";
    homepage = "https://filesender.org/";
    license = lib.licenses.bsd3;
    maintainers = with lib.maintainers; [ nhnn ];
  };
})
