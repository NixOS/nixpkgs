{
  lib,
  stdenv,
  fetchFromGitHub,
  php,
  nixosTests,
  nix-update-script,
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

    ln -s ${finalAttrs.passthru.oidcDeps}/share/php/filesender-oidc/vendor \
      $out/optional-dependencies/oidc/vendor

    runHook postInstall
  '';

  passthru = {
    oidcDeps = php.buildComposerProject2 {
      pname = "filesender-oidc";
      inherit (finalAttrs) version;
      src = "${finalAttrs.src}/optional-dependencies/oidc";
      vendorHash = "sha256-0ovOcWxzieEffmrhdC3P5Xh395G629cbfB2GbXgoU8M=";
      composerStrictValidation = false;
    };
    tests = {
      inherit (nixosTests) filesender;
    };
    updateScript = nix-update-script {
      extraArgs = [ "--subpackage=oidcDeps" ];
    };
  };

  meta = {
    description = "Web application for sending large files to other users";
    homepage = "https://filesender.org/";
    changelog = "https://github.com/filesender/filesender/releases/tag/${finalAttrs.src.tag}";
    license = lib.licenses.bsd3;
    maintainers = [ ];
    teams = with lib.teams; [ ngi ];
  };
})
