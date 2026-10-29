{
  lib,
  stdenv,
  buildGoModule,
  fetchFromGitHub,
  versionCheckHook,
}:

buildGoModule {
  pname = "goofys";
  version = "0.24.0-unstable-2022-04-21";

  __structuredAttrs = true;

  src = fetchFromGitHub {
    owner = "kahing";
    repo = "goofys";
    # Same as v0.24.0 but migrated to Go modules
    rev = "829d8e5ce20faa3f9f6f054077a14325e00e9249";
    hash = "sha256-6yVMNSwwPZlADXuPBDRlgoz4Stuz2pgv6r6+y2/C8XY=";
  };

  vendorHash = "sha256-2N8MshBo9+2q8K00eTW5So6d8ZNRzOfQkEKmxR428gI=";

  # Tests require networking
  doCheck = false;

  doInstallCheck = true;
  nativeInstallCheckInputs = [ versionCheckHook ];
  preVersionCheck = ''
    export version=0.24.0
  '';

  meta = {
    homepage = "https://github.com/kahing/goofys";
    description = "High-performance, POSIX-ish Amazon S3 file system written in Go";
    license = lib.licenses.mit;
    maintainers = [ ];
    broken = stdenv.hostPlatform.isDarwin; # needs to update gopsutil to at least v3.21.3 to include https://github.com/shirou/gopsutil/pull/1042
    mainProgram = "goofys";
  };

}
