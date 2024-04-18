{
  stdenv,
  fetchFromGitHub,
  lib,
  nixosTests,
}:
stdenv.mkDerivation rec {
  pname = "filesender";
  version = "2.47";

  src = fetchFromGitHub {
    owner = "filesender";
    repo = "filesender";
    rev = "filesender-${version}";
    hash = "sha256-49Yq2JFXA5Izl+QnGvc8hXOHIw52L09CwikGa3+F20s=";
  };

  patches = [
    # /nix/store is read-only, but filesender searches config inside of installation directory.
    # This patch changes search directory to FILESENDER_CONFIG_DIR environment variable.
    ./separate_config_dir.patch
    # same as above, but for logs
    ./separate_log_dir.patch
  ];

  installPhase = ''
    mkdir -p $out/
    cp -R . $out/
  '';

  passthru.tests = {
    inherit (nixosTests) filesender;
  };

  meta = {
    description = "Web application for sending large files to other users";
    homepage = "https://filesender.org/";
    license = lib.licenses.bsd3;
    maintainers = with lib.maintainers; [nhnn];
  };
}
