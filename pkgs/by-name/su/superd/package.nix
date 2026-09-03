{
  lib,
  buildGoModule,
  fetchFromSourcehut,
  installShellFiles,
  scdoc,
}:

buildGoModule (finalAttrs: {
  pname = "superd";
  version = "0.7.1";

  src = fetchFromSourcehut {
    owner = "~craftyguy";
    repo = "superd";
    rev = finalAttrs.version;
    hash = "sha256-5g9Y1Lpxp9cUe0sNvU5CdsTGcN+j00gIKPO9pD5j8uM=";
  };

  vendorHash = "sha256-Oa99U3THyWLjH+kWMQAHO5QAS2mmtY7M7leej+gnEqo=";

  nativeBuildInputs = [
    installShellFiles
    scdoc
  ];

  postBuild = ''
    make doc
  '';

  postInstall = ''
    installManPage superd.1 superd.service.5 superctl.1
    installShellCompletion --bash completions/bash/superctl
    installShellCompletion --zsh completions/zsh/superctl
  '';

  meta = {
    description = "Unprivileged user service supervisor";
    homepage = "https://sr.ht/~craftyguy/superd/";
    license = lib.licenses.gpl3Plus;
    platforms = lib.platforms.linux;
    maintainers = with lib.maintainers; [
      chuangzhu
      wentam
    ];
  };
})
