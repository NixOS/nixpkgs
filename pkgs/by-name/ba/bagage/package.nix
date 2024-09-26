{
  buildGoModule,
  lib,
  fetchFromGitea,
}:

buildGoModule {
  pname = "bagage";
  version = "unstable-2024-03-26";

  src = fetchFromGitea {
    domain = "git.deuxfleurs.fr";
    owner = "Deuxfleurs";
    repo = "bagage";
    rev = "75b27becf26516a65549a00378155437e4acce4e";
    hash = "sha256-SfCxMqIfNzjV7qqWe3tBzD/1Yz0EGIJg1/J1yk/bT80=";
  };

  vendorHash = "sha256-imy3MHj8BI8jxuLBzsaSxkAPtsAuh9/L1uVGWtRN8lk=";

  subPackages = [ "." ];

  meta = {
    description = ''
      Bagage is the bridge between our users and garage, it enables them to synchronize files that matter for them from their computer to garage through WebDAV.

      Bagage will be a service to access your documents everywhere. Currently, it is only a WebDAV to S3 proxy. Later, it may propose a web interface and support synchronization with the Nextcloud client.
    '';
    homepage = "https://git.deuxfleurs.fr/Deuxfleurs/bagage";
    changelog = "https://git.deuxfleurs.fr/Deuxfleurs/bagage/commits/branch/main";
    license = lib.licenses.agpl3Only;
    maintainers = with lib.maintainers; [ bhankas ];
    mainProgram = "bagage";
  };
}
