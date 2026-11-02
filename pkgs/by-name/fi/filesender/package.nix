{
  stdenv,
  fetchFromGitHub,
  lib,
  nixosTests,
}:
stdenv.mkDerivation (finalAttrs: {
  pname = "filesender";
  version = "3.15";

  src = fetchFromGitHub {
    owner = "filesender";
    repo = "filesender";
    tag = finalAttrs.version;
    hash = "sha256-IK8r0wqP2tEo1gtH4fPF5/hfXtR7rSwVUJ/Yci98kiY=";
  };

  patches = [
    # /nix/store is read-only, but filesender searches config and logs inside
    # of installation directory. This patch changes search directories to
    # `FILESENDER_CONFIG_DIR` and `FILESENDER_LOG_DIR` environment variables.
    ./separate_mutable_paths.patch
  ];

  postPatch = ''
    # remove broken symlinks
    rm docker/assets/etc/nginx/sites-enabled/default
    rm docker/assets/usr/local/sbin/php-fpm-env
  '';

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
    maintainers = [ ];
    teams = with lib.teams; [ ngi ];
  };
})
